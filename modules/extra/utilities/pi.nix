{ ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = [ pkgs.pi-coding-agent ];
      };
    };
}
