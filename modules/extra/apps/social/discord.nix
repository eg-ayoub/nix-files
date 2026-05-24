{ self, ... }:
{
  flake.nixosModules.discord =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [ firejail ];
      config = {
        environment.systemPackages = with pkgs; [
          legcord
        ];
        programs.firejail.wrappedBinaries.legcord = {
          executable = "${pkgs.legcord}/bin/legcord";
          extraArgs = [
            "--noprofile"
            "--net=wlp9s0"
          ];
        };
      };
    };
}
