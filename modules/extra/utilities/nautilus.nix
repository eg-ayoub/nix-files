{ self, ... }:
{
  flake.nixosModules.nautilus =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.zip
      ];

      config = {
        environment.systemPackages = with pkgs; [
          nautilus
        ];
        services.gvfs.enable = true;
        services.udisks2.enable = true;
      };
    };
}
