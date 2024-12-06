{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (config.go-dev)
    enable
    goVersion
    withTools
    extraPackages
    ;
in
{
  options.go-dev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable/disable the Go development environment.";
    };

    goVersion = lib.mkOption {
      type = lib.types.enum [
        "1.18"
        "1.19"
        "1.20"
        "1.21"
        "1.22"
      ]; # List of supported versions
      default = "1.23";
      description = "Specify the Go version to use.";
    };

    withTools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of Go tools to include. Use the official tool names (e.g., "golint", "gopls").
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to include in the Go environment.";
    };
  };

  config = lib.mkIf enable {
    env-packages =
      with pkgs;
      [
        (pkgs.golang."${goVersion}")
      ]
      ++ lib.optionals (withTools != [ ]) (map (tool: pkgs.${tool}) withTools)
      ++ extraPackages;

    env-hooks = [
      ''
        export GOPATH=${config.home.profileDirectory}/go
        export PATH=$GOPATH/bin:$PATH
      ''
    ];
  };
}
