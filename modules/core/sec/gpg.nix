{ ... }:
{
  flake.nixosModules.gpg = 
    { ... }:
    {
      config = {
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    };
}
