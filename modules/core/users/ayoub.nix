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
      define-rule = x: {
        command = x;
        options = ["NOPASSWD"];
      };
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
        extra-sudo-commands = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "extra sudo commands to allow passwordless for this user";
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

        security.sudo.extraRules = [
          {
            users = [ "ayoub" ];
            host = "ALL";
            runAs = "ALL:ALL";
            commands = map define-rule cfg.extra-sudo-commands;
          }
        ];
      };
    };
}
