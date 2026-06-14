# TODO: make a file like this but for keepassxc, spotify and whatsapp web
{ ... }: {
  flake.lib.makeAlacritty = { pkgs, font, colors }:
    let
      settings = {
        font = {
          size = font.alacritty_size;
          normal.family = font.name;
          normal.style = "Regular";
        };

        terminal.shell = "/run/current-system/sw/bin/bash";

        window = {
          padding = { x = 15; y = 10; };
          dynamic_title = true;
          opacity = 1.0;
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        colors = {
          bright = {
            black   = colors.base08;
            blue    = colors.base12;
            cyan    = colors.base14;
            green   = colors.base10;
            magenta = colors.base13;
            red     = colors.base09;
            white   = colors.base15;
            yellow  = colors.base11;
          };
          normal = {
            black   = colors.base00;
            blue    = colors.base04;
            cyan    = colors.base06;
            green   = colors.base02;
            magenta = colors.base05;
            red     = colors.base01;
            white   = colors.base07;
            yellow  = colors.base03;
          };
          primary = {
            background = colors.base00;
            foreground = colors.base07;
          };
          selection = {
            background = colors.base08;
            text       = colors.base07;
          };
          cursor = {
            text   = "CellBackground";
            cursor = colors.base07;
          };
        };
      };
      configFile = (pkgs.formats.toml {}).generate "alacritty.toml" settings;
    in
      pkgs.symlinkJoin {
        name = "alacritty";
        paths = [ pkgs.alacritty ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/alacritty \
            --add-flags "--config-file ${configFile}"
        '';
      };
}
