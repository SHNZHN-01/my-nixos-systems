{ inputs, ... }: {
  flake.nixosModules.neovim =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = [
        inputs.neovim-shnzhn.packages.${pkgs.stdenv.hostPlatform.system}.neovim-shnzhn
      ];
    };
}
