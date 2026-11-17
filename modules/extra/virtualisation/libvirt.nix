{ ... }:
{
  flake.nixosModules.libvirt =
    { pkgs, ... }:
    {
      config = {
        virtualisation.libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = false;
            swtpm.enable = true;
          };
        };
        environment.systemPackages = with pkgs; [
          virtiofsd
        ];
      };
    };
}
