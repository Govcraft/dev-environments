# modules/rust/default.nix
{ withSystem }:
{ config, lib, ... }:
{
  imports = [
    ./base.nix
#    ./ide.nix
  ];
  
}
