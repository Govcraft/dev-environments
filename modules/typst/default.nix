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
            enable = lib.mkEnableOption "Typst development environment";
            
            withTools = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "typst-fmt" "typst-lsp" ];
              description = "List of Typst tools to include";
            };
            
            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Additional packages to include";
            };
            
            ide = {
              type = lib.mkOption {
                type = lib.types.enum [ "vscode" "none" ];
                default = "none";
                description = "IDE preference for Typst development";
              };
            };
          };
        });
      in
      {
        options.typst-dev = lib.mkOption {
          type = mainSubmodule;
          description = lib.mdDoc ''
            Specification for the Typst development environment
          '';
          default = { };
        };
        config = lib.mkIf config.typst-dev.enable {
          env-packages.typst = [
            pkgs.typst
          ] ++ lib.optionals (config.typst-dev.ide.type == "vscode") [
            pkgs.typst-lsp
          ] ++ (map (tool: pkgs.${tool}) config.typst-dev.withTools) 
            ++ config.typst-dev.extraPackages;
          
          env-hooks.typst = ''
            echo "Typst development environment activated"
          '';
        };
      });
}
