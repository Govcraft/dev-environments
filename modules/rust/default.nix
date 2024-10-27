{ config, flake-parts-lib, lib, pkgs, ... }:
let
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
in
{
  options.perSystem = mkPerSystemOption
    ({ config, self', inputs', pkgs, system, ... }:
      let
        mainSubmodule = types.submodule ({ config, ... }: {
          options = {
            enable = lib.mkEnableOption "Rust development environment";
            withTools = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [  ];
              description = "List of Rust tools to include";
            };
            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Additional packages to include";
            };
            ide = {
              type = lib.mkOption {
                type = lib.types.enum [ "rust-rover" "vscode" "none" ];
                default = "none";
                description = "IDE preference for Rust development";
              };
            };
          };
        });
      in
      {
        options.rust-dev = lib.mkOption {
          type = mainSubmodule;
          description = lib.mdDoc ''
            Specification for the Rust development environment
          '';
          default = { };
        };

        config = lib.mkIf config.rust-dev.enable {
          env-packages.rust = [
            pkgs.rustup
            pkgs.cargo
            pkgs.llvm
            pkgs.pkg-config
          ] ++ lib.optionals (config.rust-dev.ide.type != "none") [
            pkgs.jetbrains.rust-rover
            pkgs.rust-analyzer
          ] ++ (map (tool: pkgs."cargo-${tool}") ([
            "tarpaulin"
            "release"
            "machete"
          ] ++ config.rust-dev.withTools)) ++ config.rust-dev.extraPackages;

          env-hooks.rust = ''
            rustup default stable
          '';
        };
      });
}
