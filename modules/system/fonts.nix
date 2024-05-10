{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "InconsolataGo" "JetBrainsMono" "Noto" "Recursive" ]; })
    # needed for sddm theme
    open-sans
  ];
}
