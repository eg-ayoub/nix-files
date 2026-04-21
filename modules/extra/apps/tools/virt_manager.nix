{ ... }:
{
  flake.nixosModules.virt-manager =
    { ... }:
    {
      config = {
        programs.virt-manager.enable = true;
      };
    };
}
