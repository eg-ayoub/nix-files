# ROCKSMITH

1. I used the guide in https://codeberg.org/nizo/linux-rocksmith/src/branch/main/guides/setup/nixos/flake.md

2. called this command in steam-run (patch rocksmith)
```bash
/nix/store/l973187zybmkynp438xcnafb8ylwyql6-source/scripts/patch-nixos.sh -s ~/bigdrive/Games/SteamLibrary/ -w ~/bigdrive/Games/SteamLibrary/steamapps/compatdata/221680/pfx/
```
to find the path just cat the contents of /usr/bin/patch-rocksmith.

3. for cdlc the customsforge enabler kind of sucks, find a link to the DLL online (also uploaded to proton).
