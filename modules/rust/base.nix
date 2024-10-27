{ config, lib, pkgs, ... }:
let
  cfg = config.dev.rust;
in {
  options.dev.rust = {
    enable = lib.mkEnableOption "Rust development environment";

    withIde = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include IDE tools (rust-rover, rust-analyzer)";
    };

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

    shellAliases = lib.mkOption {
      type = lib.types.attrs;
      default = {
        clippy = "cargo clippy --workspace --tests --release -- --deny warnings";
        fmt = "cargo fmt --all";
        fmtc = "cargo fmt --all -- --check";
      };
      description = "Shell aliases to include";
    };
  };

  config = lib.mkIf cfg.enable {
    perSystem = { config, system, pkgs, ... }: {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.rustup
          pkgs.cargo
          pkgs.llvm
          pkgs.pkg-config
        ] ++ lib.optionals cfg.withIde [
          pkgs.jetbrains.rust-rover
          pkgs.rust-analyzer
        ] ++ (map (tool: pkgs."cargo-${tool}") [
          "tarpaulin"
          "release"
          "machete"
        ] ++ cfg.withTools) ++ cfg.extraPackages;

        shellHook = ''
          rustup default stable
          ${lib.concatStrings (lib.mapAttrsToList (name: value: 
            "alias ${name}='${value}'\n") cfg.shellAliases)}
        '';
      };
    };
  };
}
