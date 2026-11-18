{ self, ... }:
{
  flake.nixosModules.nix =
    { config, ... }:
    let
      # system generations kept by the gc, and boot entries kept by systemd-boot: the current one
      # and the one to go back to
      kept-generations = 2;
    in
    {
      config = {
        nixpkgs.config.allowUnfree = true;

        nix = {
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          gc = {
            automatic = true;
            dates = "weekly";
            persistent = true;
            randomizedDelaySec = "45min";
          };
          optimise = {
            automatic = true;
            dates = [ "weekly" ];
          };
        };

        # keep the last generations rather than the last days: a desktop updated after a long gap
        # would otherwise lose its only rollback target
        systemd.services.nix-gc.preStart = ''
          ${config.nix.package}/bin/nix-env --profile /nix/var/nix/profiles/system \
            --delete-generations +${toString kept-generations}
        '';
        boot.loader.systemd-boot.configurationLimit = kept-generations;

        # the commit a system was built from (`nixos-version --configuration-revision`)
        system.configurationRevision = self.rev or self.dirtyRev or "unknown";
      };
    };
}
