{ lib, ... }:
{
  flake.nixosModules.pi =
    { pkgs, ... }:
    let
      # Upstream pkgs.pi-coding-agent only puts ripgrep + fd on PATH, so
      # `pi install npm:<pkg>` fails with ENOENT trying to spawn `npm`.
      # Re-wrap it to also expose nodejs (which provides node + npm), and
      # steer per-user npm state into ~/.pi/npm so it doesn't collide with
      # the user's regular ~/.npmrc setup. pi itself installs extensions
      # into ~/.pi/agent/npm via `npm install --prefix <dir>`, so this env
      # var only affects auxiliary npm calls (view, root -g, ...).
      pi-coding-agent = pkgs.symlinkJoin {
        name = "my-pi-dev";
        paths = [ pkgs.pi-coding-agent ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/pi \
            --prefix PATH : ${lib.makeBinPath [ pkgs.nodejs ]} \
            --run 'export NPM_CONFIG_PREFIX="''${NPM_CONFIG_PREFIX:-$HOME/.pi/npm}"'
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
