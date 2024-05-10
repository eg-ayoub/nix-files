{ stdenv, fetchFromGitHub }: 
{
  mywalls = stdenv.mkDerivation rec {
    pname = "mywalls";
    version = "0.1";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/aesthetic $out/nixos
      cp -a aesthetic/images/* $out/aesthetic
      cp -a nixos/wallpapers/* $out/nixos
      find $out -name "*arch*" -exec rm {} \;
    '';
    sourceRoot = ".";
    srcs = [
      (fetchFromGitHub {
        owner = "D3Ext";
        repo = "aesthetic-wallpapers";
        rev = "060c580dcc11afea2f77f9073bd8710920e176d8";
        name = "aesthetic";
        sha256 = "sha256-5MnW630EwjKOeOCIAJdSFW0fcSSY4xmfuW/w7WyIovI=";
      })
      (fetchFromGitHub {
        owner = "NixOS";
        repo = "nixos-artwork";
        rev = "f38303238fb03b89e29b6c8c2fd32e59df59a2d5";
        name = "nixos";
        sha256 = "sha256-4EiAn8n04aHcHA/DdCbwkagsSxdzADrn0CwA9ZXo+7c=";
      })
    ];
  };
}
