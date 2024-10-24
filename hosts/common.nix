{ pkgs, lib, ... }:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  boot.supportedFilesystems.zfs = lib.mkForce false;
  time.timeZone = "Europe/Berlin";
  console = {
    keyMap = "de";
    packages = with pkgs; [ terminus_font ];
    font = "ter-u28n";
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "FiraCode" ]; })
      noto-fonts
      noto-fonts-emoji

      roboto # Used for tpyst cv
      source-sans-pro # Used for typst cv
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  i18n = {
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings.LC_ALL = "de_DE.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  # Dont build man cache which can take long
  documentation.man.generateCaches = false;

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  # User
  users = {
    groups.ssh = { };
    users = {
      #disable root password
      root.hashedPassword = "!";
      guif = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialHashedPassword = "$y$j9T$hHZ1NIxqNvPno5mkSDSjI1$PojSMDbnHYHcrrdaTw74w6tSlLIRvMCbCbaCiDpMx3.";
        extraGroups = [ "wheel" "ssh" ];
      };
    };
  };
}

