{ inputs, ... }: {
  flake.nixosModules.formatter = { pkgs, ... }: {
    environment.systemPackages = [
      (inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = ".git/config";
        programs = {
          nixfmt.enable = true; # .nix   (nixfmt-rfc-style)
          stylua.enable = true; # .lua
          prettier.enable = true; # .js .ts .json .css .html .yaml .md
          ruff-format.enable = true; # .py
          gofumpt.enable = true; # .go
          rustfmt.enable = true; # .rs
          shfmt.enable = true; # .sh
          clang-format.enable = true; # .c .cpp .h .java
          taplo.enable = true; # .toml
        };
      })
    ];
  };
}
