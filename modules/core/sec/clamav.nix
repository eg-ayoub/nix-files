{ ... }:
{
  flake.nixosModules.clamav =
    { pkgs, ... }:
    {
      config = {
        # by default, scans every day at 4am "*_*_* 04:00:00"
        environment.systemPackages = [ pkgs.clamav ];
        services.clamav = {
          daemon.enable = true;
          updater.enable = true;
        };
      };
    };
}
