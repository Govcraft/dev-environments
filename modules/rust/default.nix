# dev-environments/modules/rust/module.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.dev.rust;
in {
  options.dev.rust = {
    enable = lib.mkEnableOption "Rust development environment";
    withTools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "clippy" "rustfmt" ];
      description = "List of Rust tools to include";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
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

  config = lib.mkIf cfg.enable {
    devShells.default = pkgs.mkShell {
      buildInputs = [
        pkgs.rustup
        pkgs.cargo
        pkgs.llvm
        pkgs.pkg-config
      ] ++ (map (tool: pkgs."cargo-${tool}") cfg.withTools)
        ++ cfg.extraPackages
        ++ lib.optionals (cfg.ide.type == "rust-rover") [ pkgs.jetbrains.rust-rover ];

      shellHook = ''
        rustup default stable
      '';
    };
  };
}
