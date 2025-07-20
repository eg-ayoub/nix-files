# ROCKSMITH
this took so long to fix, for posteriority, here's how I fixed it.
1. use options from this commit when it comes to sound settings, wine and steam.
   also this [link](https://github.com/theNizo/linux_rocksmith/blob/main/guides/setup/nixos/1.md)
   ONLY FOLLOW THE NIX OPTIONS

2. delete ROCKSMITH and its prefix, and re-install it.

3. choose Proton 9 prefix

4. run rocksmith once

5. CAREFULLY replicate this [script](https://github.com/wineasio/wineasio/blob/master/wineasio-register)
   from within steam-run bash
   ex.
   ```sh
   export PROTON=$HOME/bigdrive/Games/SteamLibrary/steamapps/common/Proton\ 9.0\ \(Beta\)
   export STEAMLIBRARY=$HOME/bigdrive/Games/SteamLibrary/
   export WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx
   cp /lib/wine/i386-windows/wineasio32.dll drive_c/windows/system32/wineasio32.dll
   cp /lib64/wine/x86_64-windows/wineasio64.dll drive_c/windows/syswow64/wineasio64.dll
   cd "$PROTON"
   ./bin/wine regsvr32 /lib32/wine/i386-unix/wineasio32.dll.so
   ./bin/wine64 regsvr32 /lib64/wine/x86_64-unix/wineasio64.dll.so
   ```

6. while in this context, run winecfg
   Libraries => input wineasio => Add
   scroll down and select builtin then native

7. follow this [guide](https://github.com/theNizo/linux_rocksmith/blob/main/guides/start-script/proton-9.md)
   to make a script for launching rocksmith.
   include a line for LD_PRELOAD=/lib32/libjack.so

8. add a desktop shortcut that runs the script

9. set up [RS ASIO](https://github.com/mdias/rs_asio) for rocksmith

10. reboot ?

11. start the game, may need to use patchbay to see what's plugged where.
