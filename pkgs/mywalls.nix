{ stdenv, fetchFromGitHub }: 
{
  mywalls = stdenv.mkDerivation rec {
    pname = "mywalls";
    version = "0.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/aesthetic $out/nixos
      cp -a aesthetic/images/* $out/aesthetic
      cp -a nixos/wallpapers/* $out/nixos
      find $out -name "*arch*" -exec rm {} \;
      find $out -name "*ubuntu*" -exec rm {} \;
      find $out -name "*debian*" -exec rm {} \;
      find $out -name "*windows*" -exec rm {} \;
    '';
    sourceRoot = ".";
    srcs = [
      (fetchFromGitHub {
        owner = "D3Ext";
        repo = "aesthetic-wallpapers";
        rev = "b87620b9188a512fe5c81a4688fc1bca1bfb4a41";
        name = "aesthetic";
        sha256 = "sha256-NpNjtMYQNZw1rpOVTOdltAdbh5LxHO786huLkW63yQ0=";
      })
      (fetchFromGitHub {
        owner = "NixOS";
        repo = "nixos-artwork";
        rev = "de03e887f03037e7e781a678b57fdae603c9ca20";
        name = "nixos";
        sha256 = "sha256-78FyNyGtDZogJUWcCT6A/T2MK87nGN/muC7ANH1b1V8=";
      })
    ];
  };
}
