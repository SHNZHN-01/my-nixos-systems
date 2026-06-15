{ inputs, ... }: {
  flake.nixosModules.formatter = { ... }: {
    imports = [ inputs.treefmt-nix.flakeModule ];

    treefmt = {
      programs = {
        nixfmt.enable = true;
        stylua.enable = true;
        prettier.enable = true;
        ruff-format.enable = true;
        gofumpt.enable = true;
        rustfmt.enable = true;
        shfmt.enable = true;
        clang-format.enable = true;
        taplo.enable = true;
      };
    };
  };
}
