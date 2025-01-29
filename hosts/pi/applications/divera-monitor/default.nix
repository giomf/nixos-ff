{ pkgs, config, ... }:
let
  # divera-monitor = pkgs.callPackage ./monitor.nix {};
  monitor_url = "https://app.divera247.com/monitor/1.html";
in
{
  age.secrets.divera-monitor-autologin.file = ../../../../secrets/divera-monitor-autologin.age;
  environment.defaultPackages = with pkgs; [
    chromium
    wlr-randr
  ];

  services.cage = {
    enable = true;
    user = config.users.users.guif.name;
    environment = {
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
    program = pkgs.writeShellScript "divera-monitor" ''
      AUTO_LOGIN="$(sudo cat ${config.age.secrets.divera-monitor-autologin.path})"
      wlr-randr --output Unknown-1 --transform 90
      ${pkgs.chromium}/bin/chromium \
        --kiosk \
        --incognito \
        --disable-session-crashed-bubble \
        --disable-infobars \
        --no-first-run \
        --hide-scrollbars \
        ${monitor_url}?autologin="''${AUTO_LOGIN}"
    '';
  };
}
