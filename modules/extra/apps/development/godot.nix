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
        environment = {
          systemPackages = with pkgs; [
            # godot-mono
            godotPackages_4_7.godot-mono
            gdtoolkit_4
            # androidsdk
            # jdk17
          ];
        };
        # systemd.tmpfiles.rules = [
        #   "L+ /opt/jdk17 - - - - ${pkgs.jdk17}"
        #   "L+ /opt/androidsdk - - - - ${pkgs.androidsdk}/libexec/android-sdk"
        # ];
      };
    };
}
