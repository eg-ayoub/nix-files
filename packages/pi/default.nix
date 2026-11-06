# Wrapper around a pi binary coming from elsewhere (numtide's llm-agents.nix).
# pi installs its packages with `npm install --prefix ~/.pi/agent/npm` (and git
# packages with git clone), both looked up on PATH; the upstream wrapper only
# adds ripgrep and fd, so without node on the system every `pi install` fails
# with "spawn npm ENOENT". Suffix: tools already on PATH win, these are the fallback.
#
# Deliberately input-free: the caller resolves the flake input and passes the
# base package in as `pi-agent`.
{
  pkgs,
  lib,
  pi-agent,
}:
pkgs.symlinkJoin {
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
}
