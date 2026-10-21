{ inputs, ... }:
{
  flake.nixosModules.pi =
    { lib, pkgs, ... }:
    let
      # numtide's llm-agents.nix: a newer pi, built like upstream's release binary
      pi-agent = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;

      # pi installs its packages with `npm install --prefix ~/.pi/agent/npm` (and git: packages with git clone), both
      # looked up on PATH; the package's wrapper only adds ripgrep and fd, so without node on the system every
      # `pi install` fails with "spawn npm ENOENT". Suffix: tools already on PATH win, these are the fallback.
      pi = pkgs.symlinkJoin {
        name = "pi-${pi-agent.version}";
        paths = [ pi-agent ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/pi --suffix PATH : ${
            lib.makeBinPath [
              pkgs.nodejs
              pkgs.git
            ]
          }
        '';
      };
    in
    {
      config = {
        environment.systemPackages = [ pi ];
      };
    };
}
