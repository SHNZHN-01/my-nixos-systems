{ config, ... }: let
    inherit (config.flake.lib) font colors;

    makeFcitx5Theme = { pkgs, font, colors }:
        pkgs.writeTextDir "share/fcitx5/themes/Material-Color-Black/theme.conf" ''
        [Metadata]
        Name=Material-Color-Black
        Description=Material Color Theme
        ScaleWithDPI=True

        [InputPanel]
        Font=${font.name} 13
        NormalColor=${colors.base07}
        HighlightCandidateColor=${colors.base00}
        HighlightColor=${colors.base00}
        HighlightBackgroundColor=${colors.base07}
        Spacing=0

        [InputPanel/TextMargin]
        Left=10
        Right=10
        Top=6
        Bottom=6

        [InputPanel/Background]
        Color=${colors.base00}
        BorderColor=${colors.base07}
        BorderWidth=3

        [InputPanel/Background/Margin]
        Left=2
        Right=2
        Top=2
        Bottom=2

        [InputPanel/Highlight]
        Color=${colors.base07}

        [InputPanel/Highlight/Margin]
        Left=10
        Right=10
        Top=7
        Bottom=7
        '';
in {
    flake.lib.makeFcitx5Theme = makeFcitx5Theme;

    flake.nixosModules.fcitx5 = { pkgs, config, ... }: let
        materialColorBlack = makeFcitx5Theme { inherit pkgs; font = config.theme.font; colors = config.theme.colors; };
    in {
        i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
                addons = with pkgs; [
                    qt6Packages.fcitx5-chinese-addons
                    fcitx5-gtk
                    materialColorBlack
                ];
                settings.addons.classicui.globalSection = {
                    Theme = "Material-Color-Black";
                    Font = "Sarasa Mono SC 13";
                    MenuFont = "Sarasa Mono SC 11";
                };
            };
        };

        i18n.inputMethod.fcitx5.settings.inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "keyboard-us";   # start in English, Ctrl+Space → Pinyin
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "pinyin";
        };

        i18n.inputMethod.fcitx5.ignoreUserConfig = true;
    };
}
