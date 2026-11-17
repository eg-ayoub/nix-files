{ inputs, ... }:
{
  flake.nixosModules.sops =
    { ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      config = {
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";
        # install secrets from a systemd unit, which restarts services with systemctl; the default
        # activation script asks switch-to-configuration instead, a mechanism NixOS is removing
        sops.useSystemdActivation = true;
      };
    };
}
