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
            runAsRoot = true;
            swtpm.enable = true;
          };
        };
        environment.systemPackages = with pkgs; [
          virtiofsd
        ];
        core.users.ayoub.extra-groups = [ "libvirtd" ];
      };
    };
}
