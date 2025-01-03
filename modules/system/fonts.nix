{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.inconsolata-go
    nerd-fonts.jetbrains-mono
    nerd-fonts.noto
    nerd-fonts.recursive-mono
    # needed for sddm theme
    open-sans
    # cjk font
    noto-fonts-cjk-sans
  ];
}
