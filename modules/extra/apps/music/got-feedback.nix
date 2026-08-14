{ ... }:
{
  flake.nixosModules.got-feedback =
    { pkgs, ... }:
    let
      pname = "feedback";
      version = "0.3.0";

      src = pkgs.fetchurl {
        url = "https://github.com/got-feedBack/feedBack-desktop/releases/download/nightly/feedback-${version}-x86_64.AppImage";
        hash = "sha256-5VvadJ26XQa+MjgFW8tnmA4Bzjc6ScMUpL8uEeGW7/Y=";
      };

      appimageContents = pkgs.appimageTools.extract { inherit pname version src; };

      got-feedback = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          if [ -f "${appimageContents}/${pname}.desktop" ]; then
            install -Dm444 "${appimageContents}/${pname}.desktop" -t "$out/share/applications"
            sed -i "s|Exec=AppRun|Exec=${pname}|g" "$out/share/applications/${pname}.desktop"
          fi

          if [ -d "${appimageContents}/usr/share/icons" ]; then
            cp -r "${appimageContents}/usr/share/icons" "$out/share/"
          fi

          for ext in png svg; do
            if [ -f "${appimageContents}/${pname}.$ext" ]; then
              install -Dm444 "${appimageContents}/${pname}.$ext" \
                "$out/share/icons/hicolor/512x512/apps/${pname}.$ext"
            fi
          done
        '';

        meta = {
          description = "fee[dB]ack — open-source rhythm game for real instruments";
          homepage = "https://got-feedback.org/";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      config = {
        environment.systemPackages = [ got-feedback ];
      };
    };
}
