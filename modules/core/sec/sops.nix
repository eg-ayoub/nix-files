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
      };
    };
}
