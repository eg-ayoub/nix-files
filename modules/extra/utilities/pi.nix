{ inputs, ... }:
{
  flake.nixosModules.pi =
    { pkgs, lib, ... }:
    let
      # numtide's llm-agents.nix: a newer pi, built like upstream's release binary.
      # llm-agents is a flake input, so it is resolved here and passed to the
      # input-free wrapper in ../../../packages/pi.
      #
      # pi installs its packages with `npm install --prefix ~/.pi/agent/npm` (and git
      # packages with git clone), both looked up on PATH; the package's wrapper
      # only adds ripgrep and fd, so without node on the system every `pi install`
      # fails with "spawn npm ENOENT". Suffix: tools already on PATH win, these
      # are the fallback.
      pi = (import ../../../packages/pi) {
        inherit pkgs lib;
        pi-agent = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      };
    in
    {
      config = {
        environment.systemPackages = [
          pi
          # pi-godot-helpers: runs the model's shell commands in a bwrap sandbox, and starts llama-server itself
          # (no service) while it routes review skills with a small decision model (/v1/systemone: llama.cpp >= 0.6.0)
          pkgs.bubblewrap
          pkgs.llama-cpp-vulkan
        ];
      };
    };
}
