_:
let
  colors = {
    base00 = "#000000";
    base01 = "#e67e80";
    base02 = "#a7c080";
    base03 = "#c9ad75";
    base04 = "#7fbbb3";
    base05 = "#d699b6";
    base06 = "#83c092";
    base07 = "#c8bcac";
    base08 = "#3d484d";
    base09 = "#f08a86";
    base10 = "#b3cc8c";
    base11 = "#d3b987";
    base12 = "#8fcac0";
    base13 = "#e4afc7";
    base14 = "#95d3aa";
    base15 = "#d8cabc";
  };

  font = {
    name = "Berkeley Mono";
    chinese_name = "Sarasa Gothic";
    alacritty_size = 11.0;
    polybar_size = 12;
    rofi_size = 12;
  };

  stripHash =
    str:
    if builtins.substring 0 1 str == "#" then
      builtins.substring 1 (builtins.stringLength str - 1) str
    else
      str;

  colorsNoHash = builtins.mapAttrs (_: stripHash) colors;
in
{
  flake = {
    inherit colors colorsNoHash font;

    nixosModules.theme = { lib, ... }: {
      options.theme = {
        font = {
          name = lib.mkOption {
            type = lib.types.str;
            default = font.name;
          };
          chinese_name = lib.mkOption {
            type = lib.types.str;
            default = font.chinese_name;
          };
          alacritty_size = lib.mkOption {
            type = lib.types.float;
            default = font.alacritty_size;
          };
          polybar_size = lib.mkOption {
            type = lib.types.int;
            default = font.polybar_size;
          };
          rofi_size = lib.mkOption {
            type = lib.types.int;
            default = font.rofi_size;
          };
        };
        colors = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = colors;
        };
      };
    };
  };
}
