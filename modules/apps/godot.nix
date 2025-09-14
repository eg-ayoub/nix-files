{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.godot;
in
{
  options.apps.godot = {
    enable = lib.mkEnableOption "enable godot tools";
    script = lib.mkEnableOption "install script to open gdscript in neovim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      godot-mono
      (lib.mkIf cfg.script (writeShellApplication {
        name = "godot-run-nvim";
        text = builtins.readFile ../../dotfiles/scripts/dot-local/bin/godot_run_editor.sh;
      }))
    ];
  };
}
