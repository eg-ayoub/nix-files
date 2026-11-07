{ ... }:
{
  flake.nixosModules.openwebui =
    {
      ...
    }:
    {
      config = {
        services.open-webui = {
          enable = true;
          host = "127.0.0.1";
          port = 9120;
        };

        svc.caddy.hosts."ai.poire.me".extraConfig = ''
          reverse_proxy localhost:9120
        '';
      };
    };
}
