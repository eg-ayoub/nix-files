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
        systemd.services.signal-cli = {
          description = "signal-cli daemon (REST API)";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            # REST API on loopback only; the n8n-nodes-signal-cli community node
            # gets its base URL from the user-configured `signalCliApi` credential,
            # point it at http://localhost:8087
            ExecStart = ''
              ${lib.getExe pkgs.signal-cli} daemon
              --config-path /var/lib/signal-cli
              --http 127.0.0.1:8087
            '';
            Restart = "always";

            # docker `-v signal-cli:/var/lib/signal-cli` -> systemd-managed state dir
            StateDirectory = "signal-cli";
            DynamicUser = true;

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
