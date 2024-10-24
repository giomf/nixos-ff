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

    divera-reports = {
      url = "github:giomf/divera-reports";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret handling
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # Deactivate darwin packages
      inputs.darwin.follows = "";
    };

  };

  outputs = { nixpkgs, home-manager, nixos-hardware, agenix, divera-reports, ... }: {
    nixosConfigurations = {
      "EppdPi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/pi
          divera-reports.nixosModules.default
          agenix.nixosModules.default
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
