{ ... }:
{
  flake.nixosModules.zellij =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          zellij
        ];
      };
    };
}
