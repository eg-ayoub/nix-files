{ ... }:
{
  flake.nixosModules.pywal =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          pywal16
        ];
      };
    };
}
