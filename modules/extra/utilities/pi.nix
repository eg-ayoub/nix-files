{ self, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    let
      # numtide's pi with node and git added to its PATH (packages/pi, exposed in modules/flake)
      pi = self.packages.${pkgs.stdenv.hostPlatform.system}.pi;
    in
    {
      config = {
        # pre-built packages of numtide's llm-agents.nix; trusted only where pi is installed
        nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
        nix.settings.extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];

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
