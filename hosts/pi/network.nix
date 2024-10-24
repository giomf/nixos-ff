{ lib, config, ... }:

let
  lan_interface = "lan";
  wifi_interface = "wlan0";
  ap_interface = "ap0";

in {
  # Networking
  boot.kernel.sysctl = { "net.ipv4.conf.all.forwarding" = true; };
  age.secrets.access-point-password.file = ../../secrets/access-point-password.age;
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  systemd.network = {
    enable = true;
    # broken: https://github.com/NixOS/nixpkgs/issues/247608
    wait-online.enable = false;
    links = {
      "10-lan" = {
        matchConfig.PermanentMACAddress = "b8:27:eb:3e:7c:1a";
        linkConfig.Name = "${lan_interface}";
      };
      "20-wireless" = {
        matchConfig.PermanentMACAddress = "b8:27:eb:6b:29:4f";
        linkConfig.Name = "${wifi_interface}";
      };
      "30-wireless" = {
        matchConfig.PermanentMACAddress = "08:be:ac:04:a2:dd";
        linkConfig.Name = "${ap_interface}";
      };
    };

    networks = {
      "10-lan" = {
        matchConfig.Name = "${lan_interface}";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
      "20-wireless" = {
        matchConfig.Name = "${wifi_interface}";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
      "30-access-point" = {
        matchConfig.Name = "${ap_interface}";
        networkConfig = {
          DHCP = "no";
          Address = "192.168.1.1/24";
          IPMasquerade = "ipv4";
          IPv6AcceptRA = "no";
        };
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking = {
    hostName = "EppdPi";
    useNetworkd = true;
    networkmanager.enable = false;
    firewall = {
      enable = true;
      interfaces.${ap_interface}.allowedUDPPorts = lib.optionals config.services.dnsmasq.enable [ 53 67 ];
    };
    wireless = {
      enable = true;
      interfaces = [ "${wifi_interface}" ];
      networks = { "datWLAN" = { }; };
    };
  };

  # # Enable hostapd to set up the access point on wlan1 (USB WiFi)
  services.hostapd = {
    enable = true;
    radios.${ap_interface} = {
      networks.${ap_interface} = {
        ssid = "EppdPiAP";
        # ignoreBroadcastSsid = "clear";
        authentication = {
          mode = "wpa3-sae-transition";
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
    enable = true;
    # requires = [ "hostapd.service" ];
    # after = [ "hostapd.service" ];
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
