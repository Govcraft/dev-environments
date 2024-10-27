# modules/rust/default.nix
{ withSystem }:
{ config, lib, ... }:
{
  imports = [
    ./base.nix
  ];
  
  flake = {
    # Export any flake-level configurations here if needed
  };
}
