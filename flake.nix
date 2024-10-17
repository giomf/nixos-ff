{
  description = "System flake";
  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOs hardware quirks
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }: {
    nixosConfigurations = {
      "pi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/pi
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-3
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.guif = ./hosts/pi/home.nix;
          }
        ];
      };
    };
  };
}
