{ ... }:
{
  flake.nixosModules.language-servers =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          nixd
          shellcheck
          bash-language-server
          pyright
          yaml-language-server
          marksman
          gopls
          clang-tools
          cmake-language-server
          lua-language-server
          helm-ls
          copilot-language-server
          llvmPackages.clang
        ];
      };
    };
}
