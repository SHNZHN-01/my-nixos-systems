{ self, ... }: {
  flake.nixosModules.ui =
    { config, pkgs, ... }:
    let
      inherit (config) username;
      alacritty = self.lib.makeAlacritty {
        inherit pkgs;
        font = config.theme.font;
        colors = config.theme.colors;
      };
      polybar = self.lib.makePolybar {
        inherit pkgs;
        font = config.theme.font;
        colors = config.theme.colors;
      };
      rofi = self.lib.makeRofi {
        inherit pkgs;
        font = config.theme.font;
        colors = config.theme.colors;
      };
    in
    {
      imports = [ self.nixosModules.neovim ];

      users.users.${username}.packages =
        with pkgs;
        [
          xev
          xinit
          xclip
          dunst
          flameshot
          ueberzugpp
          zathura
        ]
        ++ [
          alacritty
          polybar
          rofi
        ];
    };
}
