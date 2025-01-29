{
  description = "System flake";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "path:/home/guif/repos/private/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    pi-bsp = {
      url = "github:nix-community/raspberry-pi-nix/refs/tags/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    divera-reports = {
      url = "github:giomf/divera-reports";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    divera-status-tracker = {
      url = "github:giomf/divera-status-tracker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      agenix,
      divera-reports,
      divera-status-tracker,
      flake-utils,
      home-manager,
      nixos-hardware,
      nixpkgs,
      pi-bsp,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # Define development shells
        devShells.default = pkgs.mkShell {
          buildInputs = [
            agenix.packages.x86_64-linux.default
            pkgs.just
          ];
        };
      }
    )
    // rec {
      nixosConfigurations = {
        "EppdPi" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./hosts/pi
            agenix.nixosModules.default
            nixos-hardware.nixosModules.raspberry-pi-3
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.guif = ./hosts/pi/home.nix;
            }
          ];
        };
        "bootstrap" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./hosts/pi
            # pi-bsp.nixosModules.raspberry-pi
            nixos-hardware.nixosModules.raspberry-pi-3
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.guif = ./hosts/pi/home.nix;
            }
          ];
        };
      };
      images.bootstrap = nixosConfigurations.bootstrap.config.system.build.sdImage;
      images.eppdpi = nixosConfigurations.EppdPi.config.system.build.sdImage;
    };
}
