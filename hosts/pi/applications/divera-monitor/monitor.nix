{ lib, appimageTools, fetchurl }:

let version = "1.1.4";
in appimageTools.wrapType2 {
  name = "divera-monitor";
  src = fetchurl {
    url = "https://s3.live.divera247.de/public/software/monitor/DIVERA247-Monitor-${version}-arm64.AppImage";
    hash = "sha256-4tYydZGC113JZ2JD721EygJhaQZzs/sW+W5b0ngbk2M";
  };
  # src = fetchurl {
  #   url = "https://s3.florian.divera247.de/public/software/monitor/DIVERA247-Monitor-2.0.0-beta.13-arm64.AppImage";
  #   hash = "sha256-cioyLWHGSt1lyt6+iY85Y2rMe+xNQLtgrsJ8DooXMQU=";
  # };
  installPhase = ''
    mkdir -p $out/bin
      cp $src $out/bin/divera-monitor
      chmod +x $out/bin/divera-monitor
  '';
  meta = with lib; {
    description = "Divera Monitor";
    homepage = "https://divera247.com";
    platforms = platforms.linux;
  };
}
