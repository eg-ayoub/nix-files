{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "InconsolataGo" "JetBrainsMono" "Noto" "Recursive" ]; })
  ];
}
