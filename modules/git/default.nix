{ lib, inputs, config, pkgs, ... }:
let
  cfg = config.git;
in
{

  options.git = {
    enable = lib.mkEnableOption "enable git";
    email = lib.mkOption {
      default="ayoub.nasr.work@gmail.com";
      description="git Email address";
      type = lib.types.str;
    };
    enable-signing = lib.mkEnableOption "enable commit signing";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      signing = lib.mkIf cfg.enable-signing {
        key = "B5A7EEEDCB6DD46E";
        signByDefault = true;
      };
      settings = lib.mkIf config.editor.nvim.enable {
        core = {
          editor = "nvim";
        };
        user = {
          email = cfg.email;
          name = "Ayoub Nasr";
        };
      };
    };
    programs.diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };

}
