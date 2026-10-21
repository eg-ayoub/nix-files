{ ... }:
{
  flake.nixosModules.strata =
    { pkgs, ... }:
    let
      pname = "strata";
      version = "0.2.2";

      # the build for the RX 9070 series (gfx1200 / gfx1201): the engine, its ROCm libraries and kernels are inside
      src = pkgs.fetchurl {
        url = "https://github.com/Niko1221/Strata/releases/download/v${version}/Strata-${version}-linux-amd-rx9070.AppImage";
        hash = "sha256-TZtLOIRlJUN/O3sXKm95RJnhd0fk4jhg3FvLrdxz83c=";
      };

      strata = pkgs.appimageTools.wrapType2 (finalAttrs: {
        pname = pname;
        version = version;
        src = src;

        # the engine leaves libnuma and libelf to the system; the default fhs env has libdrm, zlib and libstdc++ already
        extraPkgs = pkgs: [
          pkgs.numactl
          pkgs.elfutils
        ];

        # the bundled python looks for the ca certificates where debian/fedora keep them: downloads fail without this
        profile = ''
          export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
        '';

        extraInstallCommands = ''
          install -m 444 -D ${finalAttrs.contents}/usr/share/applications/Strata.desktop \
            $out/share/applications/strata.desktop

          install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/strata-desktop.png \
            $out/share/icons/hicolor/512x512/apps/strata-desktop.png

          substituteInPlace $out/share/applications/strata.desktop \
            --replace-fail 'Exec=strata-desktop' 'Exec=strata'
        '';

        meta = {
          description = "Strata — local AI app for large mixture-of-experts models (AMD RX 9070 build)";
          homepage = "https://github.com/Niko1221/Strata";
          platforms = [ "x86_64-linux" ];
        };
      });
    in
    {
      config = {
        environment.systemPackages = [ strata ];
      };
    };
}
