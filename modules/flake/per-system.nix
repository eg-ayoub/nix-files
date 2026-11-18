{ ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      # `nix fmt`
      formatter = pkgs.nixfmt-tree;

      packages = {
        # `nix build .#pi`, to try the wrapper without rebuilding a host
        pi = import ../../packages/pi {
          inherit pkgs;
          inherit (pkgs) lib;
          pi-agent = inputs'.llm-agents.packages.pi;
        };

        # `nix run .#update-images`, also run weekly by the update-inputs workflow
        update-images = import ../../packages/update-images { inherit pkgs; };
      };
    };
}
