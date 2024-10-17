{ pkgs, ... }:

{
  imports = [ ../common.nix ./network.nix ];

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


  # Allow ssh in
  services.openssh.enable = true;

  sdImage.compressImage = false;
}
