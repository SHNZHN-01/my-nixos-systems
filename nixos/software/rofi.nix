{ self, ... }: {
  flake.wrappers.rofi = { wlib, lib, ... }: let
    font = self.font;
    colors = self.colors;
  in {
    imports = [ wlib.wrapperModules.rofi ];

    # `settings` is flat (attrsOf primitive) and can't express the nested
    # `timeout { }` / `filebrowser { }` blocks, so write config.rasi verbatim.
    # mkForce because `content` is types.lines — a plain def would concatenate
    # with the module's auto-generated `configuration { … }`, not replace it.
    # `theme` is left null; the @theme directive lives inline below.
    "config.rasi".content = lib.mkForce ''
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

    # Placed at $out/custom.rasi, sibling of the generated $out/rofi-config.rasi,
    # so rofi resolves the relative `@theme "custom.rasi"` against the config dir.
    constructFiles.customTheme = {
      relPath = "custom.rasi";
      content = ''
        * {
            foreground:  ${colors.base07};
            background:  ${colors.base00};
            background-color: transparent;
            text-color: ${colors.base07};
            transparent: rgba(0,0,0,0);
            font: "${font} 10";
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
            font: "${font} 8";
            color: @foreground;
        }

        inputbar {
            color: @foreground;
            padding: 11px;
            background-color: @background;
            border: 2px 2px 2px 2px;
            border-radius: 15px 15px 0px 0px;
            border-color: @foreground;
            font: "${font} 18";
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
    };
  };
}