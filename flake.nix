{
  description = "Reusable development environment configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    {
      flakeModules = {
        common = ./modules/common.nix;
        rust = {
          imports = [ ./modules/common.nix ./modules/rust ];
        };
        node = {
          imports = [ ./modules/common.nix ./modules/node ];
        };
      };
      
      flakeModule = ./modules/rust;
    };
}
