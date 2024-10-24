{ pkgs, ... }:

{
  imports = [ ../common.nix ./network.nix ./divera-reports.nix ./divera-monitor ];

  boot.loader.raspberryPi.firmwareConfig = [ "force_turbo=1" ];
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "23.05";
  nix.settings.trusted-users = [ "@wheel" ];
  environment.systemPackages = with pkgs; [ libraspberrypi ];
  environment.defaultPackages = with pkgs; [ ];

  # User
  users = {
    users = {
      "guif" = {
        openssh.authorizedKeys.keys =
          [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPI4hVcnH2C5Rq0Pkgv+rw2h1dAm2QQdyboDfW7kUlw guif@glap" ];
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      AllowGroups = [ "ssh" ];
    };
  };

  sdImage.compressImage = false;

}
