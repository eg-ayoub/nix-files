{ self, ... }:
{
  flake.nixosModules.yattee-server =
    {
      ...
    }:
    {
      imports = [
        self.nixosModules.containers
      ];

      config = {
        sops.secrets."yattee.env" = {
          sopsFile = ../../secrets/yattee.env;
          format = "dotenv";
        };
        virtualisation.oci-containers.containers.yattee-server = {
          image = "yattee-server:latest";
          environment = {
            TZ = "Etc/CET";
          };
          ports = [
            "8085:8085"
          ];
          volumes = [
            "/mnt/drive/yattee/downloads:/downloads"
            "/mnt/drive/yattee/data:/app/data"
          ];
          environment = {
            PORT = "8085";
            CORS_ORIGINS = "https://yattee.poire.me";
            SECURE_COOKIES = "true";
            DATA_DIR = "/app/data";
            DOWNLOAD_DIR = "/downloads";
          };
          environmentFiles = [
            "/run/secrets/yattee.env"
          ];
          autoStart = true;
        };
        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart podman-yattee-server.service"
        ];
        svc.caddy.hosts."yattee.poire.me".extraConfig = ''
          reverse_proxy localhost:8085
        '';
      };
    };
}
