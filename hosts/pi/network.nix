{ lib, config, ... }:

let
  lan_interface = "lan";
  wifi_interface = "wlan0";
  ap_interface = "ap0";

in
{

  imports = [
    ./access_point.nix
  ];

  # Networking
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
        networkConfig = {
          DHCP = "yes";
          # Address = "192.168.2.1/24";
        };
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
      interfaces.${ap_interface}.allowedUDPPorts = lib.optionals config.services.dnsmasq.enable [
        53
        67
      ];
    };
    wireless = {
      enable = true;
      interfaces = [ "${wifi_interface}" ];
      networks = {
        "datWLAN" = { };
      };
    };
  };

}
