{ pkgs, lib, config, ... }: 
let
  cfg = config.system.virt;
in
{
  options.system.virt = {
    enable = lib.mkEnableOption "Enable virtualization";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    programs.virt-manager.enable = true;
    environment.systemPackages = with pkgs; [
      virtiofsd
    ];
  };
}
