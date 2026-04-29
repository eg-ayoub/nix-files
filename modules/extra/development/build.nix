{ ... }:
{
  flake.nixosModules.build =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          make
        ];
      };
    };
}
