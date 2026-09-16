{ ... }:
{
  flake.nixosModules.vpn =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          ivpn
          ivpn-ui
        ];
        services.ivpn.enable = true;
      };
    };
}
