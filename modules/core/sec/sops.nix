{ inputs, ... }:
{
  flake.nixosModules.sops =
    { ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      config = {
        sops.age.keyFile = "/home/ayoub/.config/sops/age/keys.txt";
      };
    };
}
