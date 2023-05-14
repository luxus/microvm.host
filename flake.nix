# Example flake.nix
{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    figsoda-pkgs = {
      url = "github:figsoda/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  microvm = { url = "github:astro/microvm.nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
  };
    outputs = inputs@{ haumea, nixos-hardware, nixpkgs, microvm, ... }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem systems;

      module = { pkgs, ... }@args: haumea.lib.load {
        src = ./src;
        inputs = args // {
          inherit inputs;
        };
        transformer = haumea.lib.transformers.liftDefault;
      };
    in
    {
      formatter = genAttrs systems.flakeExposed
        (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations.cecile = nixosSystem {
        system = "x86_64-linux";
        modules = [
          module
          ./hardware-configuration.nix
	  # Include the microvm module
        microvm.nixosModules.microvm
        # Add more modules here
        {
          networking.hostName = "cecile";
          microvm.hypervisor = "cloud-hypervisor";
        }
        ];
      };

      packages = genAttrs systems.flakeExposed (system: {
        neovim = (nixosSystem {
          inherit system;
          modules = [ module ];
        }).config.programs.neovim.finalPackage;
      });
    };
}
