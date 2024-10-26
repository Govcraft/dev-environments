# modules/rust/default.nix
{ withSystem }:
{ config, lib, ... }:
{
  imports = [
    ./base.nix
    ./ide.nix
  ];
  
  flake = {
    # Export any flake-level configurations here if needed
  };
}
