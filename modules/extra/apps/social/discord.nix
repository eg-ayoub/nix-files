{ self, ... }:
{
  flake.nixosModules.discord =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.app.discord;
    in
    {
      imports = with self.nixosModules; [ firejail ];

      options.app.discord = {
        itf = lib.mkOption {
          type = lib.types.str;
          description = "itf to force discord traffic through";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          legcord
        ];
        # firejail only pins legcord to one interface, not a sandbox (hence --noprofile): left
        # free, it binds calls to the tailnet interface and they fail with a DTLS error
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
