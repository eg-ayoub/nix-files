{ lib, config, ... }: 
let
  cfg = config.virt;
in
{
  options.virt = {
    enable = lib.mkEnableOption "Enable virtualization";
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
