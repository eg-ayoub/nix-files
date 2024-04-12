{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "InconsolataGo" "JetBrainsMono" "Noto" "RecMono" ]; })
  ];
}
