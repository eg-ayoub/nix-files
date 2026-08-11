{ self, ... }:
{
  flake.nixosModules.mcp-searxng =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.svc.mcp-searxng;
    in
    {
      imports = [
        self.nixosModules.containers
      ];

      options.svc.mcp-searxng = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 52400;
          description = "the port on which to serve mcp-searxng";
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [ cfg.port ];
        virtualisation.oci-containers.containers.mcp-searxng = {
          image = "mcp-searxng:latest";
          environment = {
            TZ = "Etc/CET";
            MCP_HTTP_HOST = "0.0.0.0";
            MCP_HTTP_PORT = "${toString cfg.port}";
            SEARXNG_URL = "http://host.containers.internal:${toString config.svc.searxng.port}";
          };
          ports = [
            "${toString cfg.port}:${toString cfg.port}"
          ];
          autoStart = true;
        };
        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart podman-mcp-searxng.service"
        ];
      };
    };
}
