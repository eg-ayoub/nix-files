{ ... }:
{
  flake.nixosModules.n8n =
    { pkgs, lib, ... }:
    let
      # community nodes live in ../../packages/, one directory per node,
      # imported as functions receiving { pkgs, lib }
      n8n-nodes-signal-cli = import ../../packages/n8n-nodes-signal-cli { inherit pkgs lib; };
    in
    {
      config = {
        services.n8n = {
          enable = true;
          environment = {
            N8N_PORT = 5678;
            WEBHOOK_URL = "https://n8n.poire.me";
          };
          # made available to n8n via N8N_CUSTOM_EXTENSIONS; the service expects
          # packages laid out as $out/lib/node_modules/<pname>, which is exactly
          # what buildNpmPackage produces
          customNodes = [ n8n-nodes-signal-cli ];
        };
        svc.caddy.hosts."n8n.poire.me".extraConfig = ''
          reverse_proxy localhost:5678
        '';
      };
    };
}
