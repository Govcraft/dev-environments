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
      # Each module exposed individually
      flakeModules = {
        rust = ./modules/rust;
        node = ./modules/node;
      };
      
      # Keep the old flakeModule for backwards compatibility
      flakeModule = ./modules/rust;
    };
}
