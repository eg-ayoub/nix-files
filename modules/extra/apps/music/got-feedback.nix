{ ... }:
{
  flake.nixosModules.got-feedback =
    { pkgs, ... }:
    let
      pname = "got-feedback";
      version = "0.3.0";

      src = pkgs.fetchurl {
        url = "https://github.com/got-feedBack/feedBack-desktop/releases/download/nightly/feedback-${version}-x86_64.AppImage";
        hash = "sha256-5VvadJ26XQa+MjgFW8tnmA4Bzjc6ScMUpL8uEeGW7/Y=";
      };

      got-feedback = pkgs.appimageTools.wrapType2 (finalAttrs: {
        pname = pname;
        version = version;
        src = src;

        extraPkgs = pkgs: [
          pkgs.gst_all_1.gstreamer
          pkgs.alsa-lib
          pkgs.libcanberra
          pkgs.libpulseaudio
          pkgs.libx11
          pkgs.libxext
          pkgs.libxrender
          pkgs.libxcursor
          pkgs.libxinerama
          pkgs.libxrandr
          pkgs.libxcomposite
          pkgs.libxtst
          pkgs.libxfixes
          pkgs.libxi
          pkgs.xdg-utils
          pkgs.gtk3
          pkgs.gsettings-desktop-schemas
          pkgs.hicolor-icon-theme
          pkgs.glibc
        ];

        extraInstallCommands = ''
          mv $out/bin/got-feedback $out/bin/feedback

          install -m 444 -D ${finalAttrs.contents}/feedback.desktop $out/share/applications/feedback.desktop

          install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/feedback.png \
            $out/share/icons/hicolor/512x512/apps/feedback.png

          substituteInPlace $out/share/applications/feedback.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=feedback'
        '';

        meta = {
          description = "fee[dB]ack — open-source rhythm game for real instruments";
          homepage = "https://got-feedback.org/";
          platforms = [ "x86_64-linux" ];
        };
      });
    in
    {
      config = {
        environment.systemPackages = [ got-feedback ];
      };
    };
}
