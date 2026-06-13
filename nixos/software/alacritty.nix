{ self, ... }: {
  flake.wrappers.alacritty = { wlib, ... }: let
    font = self.font;
    colors = self.colors;
  in {
    imports = [ wlib.wrapperModules.alacritty ];
    settings = {
      font.size = font.alacritty_size;
      font.normal.family = "${font.name}";
      font.normal.style = "Regular";

      terminal.shell = "/run/current-system/sw/bin/bash";

      window.padding = { x = 15; y = 10; };
      window.dynamic_title = true;
      window.opacity = 1;

      scrolling.history = 10000;
      scrolling.multiplier = 3;

      colors.bright = {
        black = "${colors.base08}";
        blue = "${colors.base12}";
        cyan = "${colors.base14}";
        green = "${colors.base10}";
        magenta = "${colors.base13}";
        red = "${colors.base09}";
        white = "${colors.base15}";
        yellow = "${colors.base11}";
      };

      colors.normal = {
        black = "${colors.base00}";
        blue = "${colors.base04}";
        cyan = "${colors.base06}";
        green = "${colors.base02}";
        magenta = "${colors.base05}";
        red = "${colors.base01}";
        white = "${colors.base07}";
        yellow = "${colors.base03}";
      };

      colors.primary = {
        background = "${colors.base00}";
        foreground = "${colors.base07}";
      };

      colors.selection = {
        background = "${colors.base08}";
        text = "${colors.base07}";
      };

      colors.cursor = {
          text = "CellBackground";
          cursor = "${colors.base07}";
      };
    };
  };
}