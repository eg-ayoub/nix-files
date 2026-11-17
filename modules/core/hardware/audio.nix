{ ... }:
{
  flake.nixosModules.audio =
    { pkgs, ... }:
    {
      config = {
        services.pipewire.enable = true;
        security.rtkit.enable = true;

        environment.systemPackages = with pkgs; [
          qpwgraph
          pavucontrol
          crosspipe
        ];
      };
    };
}
