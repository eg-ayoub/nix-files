# Prebuilt TutaBridge CLI from the GitHub releases (x86_64 Linux only --
# upstream ships no sources package and no nixpkgs entry).
#
# Two things to know about the raw release binary:
#   * it asks for the generic loader (/lib64/ld-linux-x86-64.so.2) and links
#     libdbus (Secret Service keyring backend), so both are retargeted into
#     the store with patchelf before use;
#   * headless operation stores the Tuta session with `pass` (GnuPG), so the
#     wrapper pins the same environment the official container docs use:
#     HOME, XDG dirs, GNUPGHOME and PASSWORD_STORE_DIR all under DATA-DIR
#     (/var/lib/tutabridge by default, the systemd state directory of the
#     tutabridge user created by modules/services/tuta-bridge.nix).
# That means plain `sudo -u tutabridge tutabridge` just works: no env
# plumbing, and the service and manual runs agree on paths. `pass`, `gpg`
# and `git` (the password-store backends) are appended to PATH as a fallback
# suffix so tools already present win.
#
# The wrapping is done in a symlinkJoin postBuild on purpose: wrapProgram
# leaves a hidden `<name>-wrapped` ELF next to the script, and a plain
# runCommand output loses dot-files when the build dir is moved into the
# store, silently breaking the wrapper.
#
# input-free wrapper style (like ../pi): pkgs, lib, version, hash and
# data-dir are passed in by the caller (modules/services/tuta-bridge.nix).
{
  pkgs,
  lib,
  version,
  hash,
  data-dir,
}:
let
  bin = pkgs.fetchurl {
    urls = [
      "https://github.com/spartanz51/tutabridge/releases/download/${version}/tutabridge-linux-x86_64"
    ];
    inherit hash;
    name = "tutabridge-${version}";
  };
in
pkgs.symlinkJoin {
  name = "tutabridge";
  meta.mainProgram = "tutabridge";
  paths = [
    (pkgs.runCommand "tutabridge-${version}-bin"
      {
        nativeBuildInputs = [
          pkgs.patchelf
          pkgs.dbus.lib
        ];
      }
      ''
        install -Dm755 ${bin} $out/bin/tutabridge
        # retarget the loader and the libdbus reference into the store
        patchelf \
          --set-interpreter ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2 \
          --set-rpath ${pkgs.dbus.lib}/lib \
          $out/bin/tutabridge
      ''
    )
  ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/tutabridge \
      --set HOME ${data-dir} \
      --set XDG_CONFIG_HOME ${data-dir}/config \
      --set XDG_CACHE_HOME ${data-dir}/cache \
      --set GNUPGHOME ${data-dir}/gnupg \
      --set PASSWORD_STORE_DIR ${data-dir}/pass \
      --set PASSWORD_STORE_GPG_OPTS "--batch --pinentry-mode error" \
      --suffix PATH : ${
        lib.makeBinPath [
          pkgs.pass
          pkgs.gnupg
          pkgs.git
        ]
      }
  '';
}
