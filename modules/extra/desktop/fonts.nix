{ ... }:
{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      config = {
        fonts.packages = with pkgs; [
          nerd-fonts.inconsolata-go
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto
          nerd-fonts.recursive-mono
        ];
      };
    };
}
