{ lib, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    let
      # Upstream pkgs.pi-coding-agent only puts ripgrep + fd on PATH, so
      # `pi install npm:<pkg>` fails with ENOENT trying to spawn `npm`.
      # Re-wrap it to also expose nodejs (which provides node + npm).
      # pi installs extensions into ~/.pi/agent/npm via
      # `npm install --prefix <dir>`, so no NPM_CONFIG_PREFIX is needed.
      pi-coding-agent = pkgs.symlinkJoin {
        name = "my-pi-dev";
        paths = [ pkgs.pi-coding-agent ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/pi \
            --prefix PATH : ${lib.makeBinPath [ pkgs.nodejs ]}
        '';
        inherit (pkgs.pi-coding-agent) meta;
      };
    in
    {
      config = {
        environment.systemPackages = [ pi-coding-agent ];
      };
    };
}
