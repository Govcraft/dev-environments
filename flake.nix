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

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, flake-parts-lib, ... }:
    let
      inherit (flake-parts-lib) importApply;
      flakeModules.default = importApply ./modules/rust/default.nix { inherit withSystem; };
    in
    {
      imports = [
        flakeModules.default
        # inputs.foo.flakeModules.default
      ];
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      flake = {
        inherit flakeModules;
      };
    });
}
