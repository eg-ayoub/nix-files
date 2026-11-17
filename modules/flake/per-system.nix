{ ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      # `nix fmt`
      formatter = pkgs.nixfmt-tree;

      # `nix build .#pi`, to try the wrapper without rebuilding a host
      packages.pi = import ../../packages/pi {
        inherit pkgs;
        inherit (pkgs) lib;
        pi-agent = inputs'.llm-agents.packages.pi;
      };
    };
}
