{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  cfg = config.git;
in
{

  options.git = {
    enable = lib.mkEnableOption "enable git";
    email = lib.mkOption {
      default = "ayoub.nasr.work@gmail.com";
      description = "git Email address";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
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
