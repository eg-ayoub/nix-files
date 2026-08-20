{ ... }:
{
  flake.nixosModules.zip =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          zip
          p7zip
        ];
      };
    };
}
