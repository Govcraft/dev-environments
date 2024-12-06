{
  config,
  flake-parts-lib,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake-parts-lib)
    mkPerSystemOption
    ;
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.perSystem = mkPerSystemOption (
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    let
      mainSubmodule = types.submodule (
        { config, ... }:
        {
          options = {
            enable = lib.mkEnableOption "Golang development environment";

            goVersion = lib.mkOption {
              type = lib.types.enum [
                "1.18"
                "1.19"
                "1.20"
                "1.21"
                "1.22"
                "1.23"
              ];
              default = "1.23";
              description = "Golang toolchain version to use";
            };

            withTools = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of Golang tools to include (e.g., gopls, golint)";
            };

            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Additional packages to include";
            };
          };
        }
      );
    in
    {
      options.go-dev = lib.mkOption {
        type = mainSubmodule;
        description = lib.mdDoc ''

          Specification for the Golang development environment
        '';
        default = { };
      };

      config = lib.mkIf config.go-dev.enable {
        env-packages.go = [
          (pkgs.go)
        ] ++ (map (tool: pkgs."${tool}") config.go-dev.withTools) ++ config.go-dev.extraPackages;

        env-hooks.go = ''

          export GOPATH=$PWD/go
          export PATH=$GOPATH/bin:$PATH
        '';
      };
    }
  );
}
