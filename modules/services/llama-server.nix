{ ... }:
{
  flake.nixosModules.llama-server =
    { pkgs, ... }:
    let
      models-dir = "/var/lib/llama-models";
    in
    {
      config = {
        services.llama-cpp = {
          enable = true;
          package = pkgs.llama-cpp-vulkan;
          modelsDir = models-dir;
          extraFlags = [
            "--sleep-idle-seconds"
            "3600"
            "--models-max"
            "2"
          ];
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
