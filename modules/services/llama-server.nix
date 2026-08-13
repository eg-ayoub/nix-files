{ ... }:
{
  flake.nixosModules.llama-server =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.svc.llama-server;
      models-dir = "/var/lib/llama-models";
    in
    {
      options.svc.llama-server = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "address to bind llama-server to";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "port on which to serve llama-server";
        };
      };
      config = {
        services.llama-cpp = {
          enable = true;
          package = pkgs.llama-cpp-vulkan;
          settings = {
            host = cfg.host;
            port = cfg.port;
            sleep-idle-seconds = 1800;
            models-max = 2;
            models-preset = "${models-dir}/presets.ini";
          };
          openFirewall = true;
        };
        systemd.services.llama-cpp = {
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-cpp";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
          };
        };
        systemd.tmpfiles.rules = [ "d ${models-dir} 0755 root root -" ];
      };
    };
}
