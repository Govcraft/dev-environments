# modules/rust/default.nix
{ config, lib, pkgs, ... }:
{
  imports = [
    ./base.nix
    ./ide.nix
  ];

  # This file can include any shared configurations or expose combined options
  # that are common across Rust development environments
}
