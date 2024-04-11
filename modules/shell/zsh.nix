{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.shell.zsh;
in
{
  options.shell.zsh = {
    enable = lib.mkEnableOption "enable zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        gfpush = "ggpush --force";
        lssh = "TERM=xterm ssh -F ssh_config";
        lscp = "scp -F ssh_config";
        nv = "nvim .";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/command-not-found"; tags = [ "from:oh-my-zsh" ]; }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
      };
    };
  };

}
