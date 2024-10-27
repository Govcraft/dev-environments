# modules/rust/default.nix
{ withSystem }:
{ config, lib, ... }:
{
  imports = [
    ./base.nix
#    ./ide.nix
  ];
  
  flake = {
    dev.rust;
    # Export any flake-level configurations here if needed
  };
}
