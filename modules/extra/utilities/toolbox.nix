{ ... }:
{
  flake.nixosModules.terminal-toolbox =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          vim
          git
          curl
          lshw
          fastfetch
          stow
          ripgrep
        ];
      };
    };
}
