{ lib, pkgs, ... }:

{
  imports = [
    ../../common/server.nix
    # ./bsp.nix
    ./network.nix
  ];

  # DEBUG
  boot.crashDump = {
    architectureOptions = [ ];
    kernelParams = [
      "1"
      "boot.shell_on_fail"
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
    enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  boot.supportedFilesystems.zfs = lib.mkForce false;

  documentation.man.generateCaches = false;

  system.stateVersion = "23.05";
  nix.settings.trusted-users = [ "@wheel" ];
  environment.systemPackages = with pkgs; [ libraspberrypi ];
  environment.defaultPackages = with pkgs; [ ];
  sdImage.compressImage = false;
}
