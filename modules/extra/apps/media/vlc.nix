{ ... }:
{
  flake.nixosModules.vlc =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          vlc
        ];
      };
    };
}
