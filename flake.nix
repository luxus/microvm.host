# Example flake.nix
{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixpkgs.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ haumea, nixpkgs, microvm, ... }:
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
      nixosConfigurations.cecile = nixosSystem {
        system = "x86_64-linux";
        modules = [
          module
          ./hardware-configuration.nix
          # Include the microvm module
          microvm.nixosModules.microvm
          # Add more modules here
          { }
        ];
      };
    };
}
