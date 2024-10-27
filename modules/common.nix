{ config, flake-parts-lib, lib, pkgs, ... }:
let
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
in
{
  options = {
    perSystem = mkPerSystemOption
      ({ config, self', inputs', pkgs, system, ... }: {
        options = {
          env-packages = lib.mkOption {
            type = lib.types.attrsOf (lib.types.listOf lib.types.package);
            default = {};
            description = "Packages for development environments";
          };

          env-hooks = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
            description = "Shell hooks for development environments";
          };
        };
      });
  };
}
