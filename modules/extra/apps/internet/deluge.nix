{ ... }:
{
  flake.nixosModules.deluge =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          deluge
        ];
      };
    };
}
