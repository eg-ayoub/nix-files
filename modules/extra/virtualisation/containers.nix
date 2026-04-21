{ ... }:
{
  flake.nixosModules.containers =
    { pkgs, ... }:
    {
      config = {
        virtualisation = {
          containers.enable = true;
          podman = {
            enable = true;
            dockerCompat = true;
            dockerSocket.enable = true;
            autoPrune.enable = true;
          };
          oci-containers.backend = "podman";
        };

        # Useful other development tools
        environment.systemPackages = with pkgs; [
          dive # look into docker image layers
          podman-tui # status of containers in the terminal
        ];
      };
    };
}
