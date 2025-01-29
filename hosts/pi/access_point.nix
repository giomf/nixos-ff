{ config, ... }:

let
  wifi_interface = "wlan0";
  ap_interface = "ap0";
in
{

  age.secrets.access-point-password.file = ../../secrets/access-point-password.age;
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };

  services.create_ap = {
    enable = false;
    settings = {
      CHANNEL = "6";
      INTERNET_IFACE = "${wifi_interface}";
      PASSPHRASE = "12345678";
      SSID = "EppdPi";
      WIFI_IFACE = "${ap_interface}";
    };
  };

  # # Enable hostapd to set up the access point on wlan1 (USB WiFi)
  services.hostapd = {
    enable = true;
    radios.${ap_interface} = {
      # Disable ACS (Automatic Channel Selection)
      channel = 6;
      # countryCode = "DE";
      # wifi4.enable = false; # Disable Wifi4 and HT40 because of ACS
      networks.${ap_interface} = {
        ssid = "EppdPiAP";
        authentication = {
          mode = "wpa3-sae-transition";
          # mode = "none";
          saePasswordsFile = config.age.secrets.access-point-password.path;
          wpaPasswordFile = config.age.secrets.access-point-password.path;
        };
      };
    };
  };

  # Sometimes slow connection speeds are attributed to absence of haveged.
  services.haveged.enable = config.services.hostapd.enable;

  # # Enable DHCP server for devices connecting to the access point (USB WiFi)
  services.dnsmasq = {
    enable = config.services.hostapd.enable;
    settings = {
      interface = [ "${ap_interface}" ];
      bind-interfaces = true;
      except-interface = [ "lo" ];
      dhcp-range = [ "192.168.1.10,192.168.1.100,12h" ];
      listen-address = [ "192.168.1.1" ];
    };
  };

  systemd.services.dnsmasq = {
    requires = [ "${config.systemd.services.hostapd.name}" ];
    after = [ "${config.systemd.services.hostapd.name}" ];
  };
}
