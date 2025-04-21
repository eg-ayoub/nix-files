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
        glc = "git log --format='%H' -n 1";
        lssh = "TERM=xterm ssh -F ssh_config";
        lscp = "scp -F ssh_config";
        lv = "nvim .";
        fv = "fzf --bind 'enter:become(nvim {})'";
        v = "nvim";
      };
      historySubstringSearch.enable = true;
      antidote = {
        enable = true;
        plugins = [
          "getantidote/use-omz"
          "ohmyzsh/ohmyzsh path:lib"
          "ohmyzsh/ohmyzsh path:plugins/git"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "joshskidmore/zsh-fzf-history-search"
        ];
      };
      initExtra = ''
      bindkey '^[OA' history-beginning-search-backward
      bindkey '^[OB' history-beginning-search-forward

      bindkey -r '<Right>'
      bindkey '^ ' autosuggest-accept

      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      gpg-connect-agent updatestartuptty /bye > /dev/null
      '';
    };
  };

}
