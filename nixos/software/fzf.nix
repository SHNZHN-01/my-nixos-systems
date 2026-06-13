# nix/utils/fzf.nix — builds the package, it doesn't end up in nixosModules (no install)
{ self, ... }: {
  perSystem = { pkgs, ... }: {
    wrappers.packages.fzf = true;
    packages.fzf = self.wrappers.fzf.wrap {
      inherit pkgs;
      fzf_default_opts = "--height=40% --layout=reverse --prompt=> ";
    };
  };
}