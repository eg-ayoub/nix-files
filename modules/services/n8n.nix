{ ... }:
{
  flake.nixosModules.n8n =
    { ... }:
    {
      config = {
        services.n8n = {
          enable = true;
          environment = {
            N8N_PORT = 5678;
            WEBHOOK_URL = "https://n8n.poire.me";
          };
        };
        svc.caddy.hosts."n8n.poire.me".extraConfig = ''
          reverse_proxy localhost:5678
        '';
      };
    };
}
