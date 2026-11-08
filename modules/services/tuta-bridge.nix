{ ... }:
{
  flake.nixosModules.tuta-bridge =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.svc.tuta-bridge;
      version = "v0.1.0-rc.16";
      hash = "sha256:328fcec47c173502896a8166d22a656dd86c221104810a910786089cc7b11e86";
      data-dir = "/var/lib/tutabridge";
      tutabridge = import ../../packages/tutabridge {
        inherit
          pkgs
          lib
          version
          hash
          data-dir
          ;
      };

      # Headless (non-desktop) prep, run as the tutabridge user before the
      # daemon starts. Mirrors what the official container entrypoint does:
      # seed config.toml (ports + pass session backend) and initialize a
      # passphrase-less GPG key + `pass init` so the bridge can persist its
      # Tuta session without a desktop keyring (Secret Service). Idempotent.
      prepare = pkgs.runCommand "tutabridge-prepare" { } ''
        cp ${./tuta-bridge/prepare.sh} $out
        sed -i \
          -e "s#@DATA@#${data-dir}#g" \
          -e "s#@EMAIL@#${cfg.email}#g" \
          -e "s#@IMAP_PORT@#${toString cfg.imap-port}#g" \
          -e "s#@SMTP_PORT@#${toString cfg.smtp-port}#g" \
          $out
        chmod +x $out
      '';
      # gpg/pass/awk/grep are not in the default build PATH, so the
      # service runs the prepared script through a wrapper that pins them.
      prepareCmd = pkgs.writeShellScriptBin "tutabridge-prepare" ''
        export PATH=${
          lib.makeBinPath [
            pkgs.gnupg
            pkgs.pass
            pkgs.gawk
            pkgs.gnugrep
            pkgs.coreutils
            pkgs.git
          ]
        }:$PATH
        exec ${prepare}
      '';
    in
    {
      options.svc.tuta-bridge = {
        imap-port = lib.mkOption {
          type = lib.types.port;
          default = 1143;
          description = "the port on which to serve tuta-bridge IMAP";
        };
        smtp-port = lib.mkOption {
          type = lib.types.port;
          default = 1025;
          description = "the port on which to serve tuta-bridge SMTP";
        };
        email = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Tuta address of the account this bridge serves; written verbatim into config.toml on first start (leave empty to fill it in by hand and restart)";
        };
      };

      config = {

        # named user so state can be managed by hand with sudo -u
        # (DynamicUser would get a random uid, impossible to sudo into).
        # The CLI wrapper bakes the paths in, so both the service and
        #   sudo -u tutabridge tutabridge
        # agree on /var/lib/tutabridge.
        users.groups.tutabridge = { };
        users.users.tutabridge = {
          isSystemUser = true;
          group = "tutabridge";
          shell = "/run/current-system/sw/bin/nologin";
        };

        # the release CLI, installed system-wide (wrapper pins the session
        # and cache paths under /var/lib/tutabridge)
        environment.systemPackages = [ tutabridge ];

        systemd.services.tutabridge = {
          description = "TutaBridge — local IMAP/SMTP bridge for Tuta encrypted email";

          # first sign-in has to be interactive once (it seeds the pass
          # session); after that the daemon resumes it without prompting:
          #   sudo -u tutabridge tutabridge           # sign in, runs the bridge
          #   sudo -u tutabridge tutabridge password  # bridge password for the mail client
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            User = "tutabridge";
            Group = "tutabridge";

            # docker `-v tutabridge:/data` -> systemd-managed state dir
            # (0700, owned by tutabridge; matches the wrapper baked-in paths)
            StateDirectory = "tutabridge";

            # seed config.toml + GPG/pass store on first start (runs as the
            # service user thanks to User=)
            ExecStartPre = "${lib.getExe prepareCmd}";

            # plain `tutabridge` serves IMAP+SMTP on 127.0.0.1 until stopped;
            # with no saved session it cannot prompt headless and exits, so
            # it keeps failing until the interactive sign-in above has run
            ExecStart = "${lib.getExe tutabridge}";
            Restart = "on-failure";
            RestartSec = 5;

            # Keep logs at info; override with `systemctl edit tutabridge` if needed.
            # unit keys are case-sensitive (systemd ignores `environment=`),
            # so use the canonical directive name
            Environment = [ "RUST_LOG=info" ];

            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ProtectHome = true;
          };
        };
      };
    };
}
