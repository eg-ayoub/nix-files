{ ... }:
{
  flake.nixosModules.jan =
    { pkgs, ... }:
    {
      config = {
        # local llm app on llama.cpp: pick the vulkan backend in its settings for the radeon
        environment.systemPackages = with pkgs; [
          jan
        ];
      };
    };
}
