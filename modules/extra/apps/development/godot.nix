{ self, ... }:
{
  flake.nixosModules.godot =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.build
        self.nixosModules.pre-commit
      ];

      config = {
        environment.systemPackages = with pkgs; [
          godot-mono
          gdtoolkit_4
        ];
      };
    };
}
