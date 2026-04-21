{ ... }:
{
  flake.nixosModules.ssh =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          openssh
        ];
      };
    };
}
