{ ... }:
{
  flake.nixosModules.auto-recovery =
    { ... }:
    {
      config = {
        # a CPU stuck in the kernel panics it, and a panic reboots after 60s
        boot.kernel.sysctl = {
          "kernel.softlockup_panic" = 1;
          "kernel.panic" = 60;
        };

        # if the kernel freezes completely, the board's hardware watchdog reboots the machine
        systemd.settings.Manager.RuntimeWatchdogSec = "30s";
      };
    };
}
