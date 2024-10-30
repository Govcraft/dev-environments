{
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.typst-dev;
in {
  options.typst-dev = {
    enable = mkEnableOption "Typst development environment";
    
    withTools = mkOption {
      type = types.listOf types.str;
      default = [ "typst-fmt" "typst-lsp" ];
      description = "List of Typst tools to include";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to include in the environment";
    };

    ide = {
      type = mkOption {
        type = types.enum [ "vscode" "none" ];
        default = "none";
        description = "IDE preference for Typst development";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    env-packages.typst = with pkgs; [
      typst
    ] ++ (map (tool: pkgs.${tool}) cfg.withTools)
      ++ cfg.extraPackages;

    env-hooks.typst = ''
      echo "Typst development environment activated"
    '';
  };
}
