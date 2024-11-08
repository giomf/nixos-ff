{
  description = "System flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
      nixpkgs,
      flake-utils,
      home-manager,
      nixos-hardware,
      agenix,
      divera-status-tracker,
      divera-reports,
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
          ];
        };
      }
    )
    // {
      nixosConfigurations = {
        "EppdPi" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/pi
            divera-reports.nixosModules.default
            divera-status-tracker.nixosModules.default
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
