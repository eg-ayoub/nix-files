{ ... }:
{
  flake.nixosModules.opencode =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          opencode
        ];
      };
    };
}
