{ ... }:
{
  flake.nixosModules.signal-cli =
    { pkgs, lib, ... }:
    {
      config = {
        # equivalent of:
        #   docker run -d --name signal-cli --restart=always \
        #     -p 8085:8085 -v signal-cli:/var/lib/signal-cli \
        #     registry.gitlab.com/packaging/signal-cli/signal-cli-native:latest \
        #     daemon --http=0.0.0.0:8085
        # (port 7583 in that command is just signal-cli's own control port,
        # always on loopback, nothing to expose)
        # note: signal-cli 0.14.x renamed --config-path/-p to --data-dir/-d
        # (alias --config/-c); the daemon subcommand still uses --http
        # named system user so the account/state dir can be managed with
        # `sudo -u signal-cli signal-cli -p /var/lib/signal-cli register ...`
        # (DynamicUser would get a random uid, impossible to sudo into)
        users.groups.signal-cli = { };
        users.users.signal-cli = {
          isSystemUser = true;
          group = "signal-cli";
          shell = "/run/current-system/sw/bin/nologin";
        };

        systemd.services.signal-cli = {
          description = "signal-cli daemon (REST API)";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            # REST API on loopback only; the n8n-nodes-signal-cli community node
            # gets its base URL from the user-configured `signalCliApi` credential,
            # point it at http://localhost:8087
            ExecStart = ''
              ${lib.getExe pkgs.signal-cli} --data-dir=/var/lib/signal-cli daemon --http=127.0.0.1:8087
            '';
            Restart = "always";
            User = "signal-cli";
            Group = "signal-cli";

            # docker `-v signal-cli:/var/lib/signal-cli` -> systemd-managed state dir
            StateDirectory = "signal-cli";

            # docker `--tmpfs /tmp:exec`
            PrivateTmp = true;
            Tmpfs = [ "/tmp:exec" ];

            # docker `--shm-size=64m`
            SharedMemorySize = "64M";

            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ProtectHome = true;
          };
        };
      };
    };
}
