{ ... }:
{
  flake.nixosModules.rpcs3 =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          rpcs3
        ];
      };
    };
}
