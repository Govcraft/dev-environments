# modules/rust/ide.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.dev.rust.ide;
in {
  options.dev.rust.ide = {
    type = lib.mkOption {
      type = lib.types.enum [ "rust-rover" "vscode" "none" ];
      default = "none";
      description = "IDE preference for Rust development";
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional IDE extensions to include";
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "IDE-specific settings";
    };
  };

  config = lib.mkIf (cfg.type != "none") {
    perSystem = { pkgs, system, config, ... }: {
      dev.rust.extraPackages = lib.optionals (cfg.type == "rust-rover") [
        pkgs.jetbrains.rust-rover
      ] ++ lib.optionals (cfg.type == "vscode") [
        pkgs.vscode
        pkgs.rust-analyzer
      ] ++ cfg.extensions;

      devShells.default = pkgs.mkShell {
        shellHook = lib.mkIf (cfg.type == "vscode") ''
          if [ ! -d .vscode ]; then
            mkdir .vscode
            cat > .vscode/settings.json << EOF
            ${builtins.toJSON cfg.settings}
            EOF
          fi
        '';
      };
    };
  };
}
