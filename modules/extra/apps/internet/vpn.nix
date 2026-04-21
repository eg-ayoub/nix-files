{ ... }:
{
  flake.nixosModules.vpn =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          proton-vpn
        ];
      };
    };
}
