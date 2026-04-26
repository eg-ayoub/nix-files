{ ... }:
{
  flake.nixosModules.godot =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          godot-mono
        ];
      };
    };
}
