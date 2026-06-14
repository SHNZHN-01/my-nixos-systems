{ ... }: {
  flake.lib.makeRofi = { pkgs, font, colors }:
    let
      configRasi = pkgs.writeText "config.rasi" ''
        configuration {
            drun-display-format: "{name}";
            timeout {
                action: "kb-cancel";
                delay:  0;
            }
            filebrowser {
                directories-first: true;
                sorting-method:    "name";
            }
        }

        @theme "custom.rasi"
      '';

      customRasi = pkgs.writeText "custom.rasi" ''
        * {
            foreground:  ${colors.base07};
            background:  ${colors.base00};
            background-color: transparent;
            text-color: ${colors.base07};
            transparent: rgba(0,0,0,0);
            font: "${font.name} ${toString font.rofi_size}";
            highlight: underline bold ${colors.base07};
            green: ${colors.base02};
            aqua: ${colors.base06};
            red: ${colors.base01};
            yellow: ${colors.base03};
            purple: ${colors.base05};
            blue: ${colors.base04};
            disabled: ${colors.base08};
        }

        window {
            width: 30%;
            location: center;
            anchor:   center;
            transparency: "screenshot";
            color: @foreground;
            padding: 10px;
            border:  0px;
            border-radius: 10px;
            background-color: @transparent;
            spacing: 0;
            children:  [mainbox];
            orientation: horizontal;
        }

        mainbox {
            spacing: 0;
            children: [inputbar, message, listview];
        }

        message {
            border-color: @foreground;
            border: 0px 2px 2px 2px;
            border-radius: 10px;
            padding: 5;
            background-color: @background;
            font: "${font.name} 8";
            color: @foreground;
        }

        inputbar {
            color: @foreground;
            padding: 11px;
            background-color: @background;
            border: 2px 2px 2px 2px;
            border-radius: 15px 15px 0px 0px;
            border-color: @foreground;
            font: "${font.name} 18";
        }

        entry, prompt, case-indicator {
            text-font: inherit;
            text-color: inherit;
        }

        prompt {
            enabled: false;
        }

        listview {
            padding: 8px;
            border-radius: 0px 0px 15px 15px;
            border-color: @foreground;
            border: 0px 2px 2px 2px;
            background-color: @background;
            dynamic: false;
            lines: 10;
        }

        element {
            padding: 3px;
            vertical-align: 0.5;
            border: 2px;
            border-radius: 4px;
            background-color: inherit;
            color: @foreground;
            font: inherit;
        }

        element-text {
            background-color: inherit;
            text-color: inherit;
        }

        element selected.normal {
            background-color: ${colors.base08};
            border: 2px;
            border-color: @foreground;
        }

        error-message {
            expand: true;
            border: 2px;
            border-radius: 2px;
            border-color: @red;
            background-color: @background;
            padding: 1em;
        }
      '';

      rofiConfig = pkgs.linkFarm "rofi-config" [
        { name = "config.rasi"; path = configRasi; }
        { name = "custom.rasi"; path = customRasi; }
      ];
    in
      pkgs.symlinkJoin {
        name = "rofi";
        paths = [ pkgs.rofi ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/rofi \
            --add-flags "-config ${rofiConfig}/config.rasi"
        '';
      };
}
