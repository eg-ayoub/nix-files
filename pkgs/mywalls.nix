{ stdenv, fetchFromGitHub }: 
{
  mywalls = stdenv.mkDerivation rec {
    pname = "mywalls";
    version = "0.2";
    dontBuild = true;
    preInstall = ''
      mkdir -p $out/share/wallpapers/aesthetic $out/share/wallpapers/nixos
    '';
    installPhase = ''
      runHook preInstall
      cp -a aesthetic/images/* $out/share/wallpapers/aesthetic
      cp -a nixos/wallpapers/* $out/share/wallpapers/nixos
      runHook postInstall
    '';
    postInstall = ''
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
        sha256 = "sha256-6prGU+tfGf6GjyYqzZAnocKom6VgoxS8E+6TXy8YrRA=";
      })
    ];
  };
}
