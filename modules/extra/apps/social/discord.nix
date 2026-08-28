{ self, ... }:
{
  flake.nixosModules.discord =
    { lib, config, pkgs, ... }:
    let
      cfg = config.app.discord;
    in
    {
      imports = with self.nixosModules; [ firejail ];

      options.app.discord = {
        itf = lib.mkOption {
          type = lib.types.str;
          default = "wlp9s0";
          description = "itf to force discord traffic through";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          legcord
        ];
        programs.firejail.wrappedBinaries.legcord = {
          executable = "${pkgs.legcord}/bin/legcord";
          extraArgs = [
            "--noprofile"
            "--net=${cfg.itf}"
          ];
        };
      };
    };
}
