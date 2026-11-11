{ ... }:
{
  flake.nixosModules.n8n =
    { pkgs, lib, ... }:
    let
      # community nodes live in ../../packages/, one directory per node,
      # imported as functions receiving { pkgs, lib }
      n8n-nodes-signal-cli = import ../../packages/n8n-nodes-signal-cli { inherit pkgs lib; };
      n8n-nodes-vikunja = import ../../packages/n8n-nodes-vikunja { inherit pkgs lib; };
    in
    {
      config = {
        services.postgresql = {
          enable = true;
          ensureDatabases = [ "n8n" ];
          enableTCPIP = true;
          authentication = lib.mkOverride 10 ''
            #type database DBUSER auth-method
            local all      all    trust
            host  sameuser all    127.0.0.1/32 scram-sha-256
            host  sameuser all    ::1/128 scram-sha-256
          '';
          ensureUsers = [
            {
              name = "n8n";
              ensureDBOwnership = true;
              ensureClauses = {
                login = true;
              };
            }
          ];
        };
        services.n8n = {
          enable = true;
          environment = {
            N8N_PORT = 5678;
            WEBHOOK_URL = "https://n8n.poire.me";
          };
          # made available to n8n via N8N_CUSTOM_EXTENSIONS; the service expects
          # packages laid out as $out/lib/node_modules/<pname>, which is exactly
          # what buildNpmPackage produces
          customNodes = [
            n8n-nodes-signal-cli
            n8n-nodes-vikunja
          ];
        };
        svc.caddy.hosts."n8n.poire.me".extraConfig = ''
          reverse_proxy localhost:5678
        '';
      };
    };
}
