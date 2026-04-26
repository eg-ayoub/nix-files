{ self, ... }:
{
  flake.nixosModules.ayoub-user =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.core.users.ayoub;
    in
    {

      imports = [
        self.nixosModules.zsh
      ];

      options.core.users.ayoub = {
        extra-groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "extra groups to add ayoub user to";
          default = [ ];
        };
      };

      config = {
        users.users.ayoub = {
          uid = 1000;
          name = "ayoub";
          home = "/home/ayoub";
          description = "ol' trickster boi";
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
          ]
          ++ cfg.extra-groups;
          shell = pkgs.zsh;
        };

        nix.settings.trusted-users = [
          "root"
          "ayoub"
        ];
      };
    };
}
