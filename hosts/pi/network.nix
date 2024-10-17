{ ... }:

let

  onboard_wifi_interface = "wlan0";
  usb_wifi_interface = "wlp1s0u1u2";

in {
  # Networking
  networking = {
    hostName = "pi";
    networkmanager.enable = true;
    networkmanager.unmanaged = [ "${usb_wifi_interface}" ];
    firewall.trustedInterfaces = [ "${usb_wifi_interface}" ];
    # wireless.enable = true;

    # Onboard WiFi
    #   interfaces.${onboard_wifi_interface} = {
    #     useDHCP = true;
    #     wireless = {
    #       enable = true;
    #       ssid = "WILLY.TEL-NMB5PNQY42";
    #       password = "89181455045934548012";
    #     };
    #   };

    # # USB WiFi stick (access point mode)
    interfaces.${usb_wifi_interface} = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.1";
        prefixLength = 24;
      }];
    };
  };

  # # Enable hostapd to set up the access point on wlan1 (USB WiFi)
  services.hostapd = {
    enable = true;
    radios.${usb_wifi_interface} = {
      networks.${usb_wifi_interface} = {
        ssid = "MyPiAp";
        authentication = {
          mode = "wpa3-sae-transition";
          saePasswords = [{ password = "password"; }]; # Use saePasswordsFile if possible.
          wpaPassword = "password";
        };
      };
    };
  };

  # # Enable DHCP server for devices connecting to the access point (USB WiFi)
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ "${usb_wifi_interface}" ]; # Listen on the USB WiFi interface
      dhcp-range = [ "192.168.1.10,192.168.1.100" ];
      listen-address = "192.168.1.1";
    };
  };
}
