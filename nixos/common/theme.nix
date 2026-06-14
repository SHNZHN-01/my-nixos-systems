{ ... }:
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

  # let s:white    = "#c8bcac" " Foreground (slightly dimmed warm off-white)
  # "let s:black1   = "#272e33" " Background hard
  # let s:black1   = "#000000" " Background hard
  # let s:black2   = "#2e383c" " Background medium
  # let s:yellow   = "#c9ad75" " Yellow (slightly dimmed)
  # let s:blue     = "#7fbbb3" " Blue
  # let s:green    = "#a7c080" " Green
  # let s:turqoise = "#83c092" " Aqua
  # let s:orange   = "#e69875" " Orange
  # let s:pink     = "#d699b6" " Purple
  # let s:red      = "#e67e80" " Red
  # let s:gray1    = "#343f44" " Background soft
  # let s:gray2    = "#3d484d" " Grey0
  # let s:gray3    = "#475258" " Grey1
  # let s:gray4    = "#576268" " Grey2
  # let s:gray5    = "#7a8478" " Grey light
  # let s:gray6    = "#4a555b" " Grey dim (darker for better blending)

  font = {
    name = "JetBrainsMono Nerd Font Mono";
    alacritty_size = 10.5;
    polybar_size = 10;
    rofi_size = 10;

    # name = "Terminess Nerd Font Mono";
    # alacritty_size = 12;
    # polybar_size = 11;
    # rofi_size = 12;
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  colorsNoHash = builtins.mapAttrs (_: v: stripHash v) colors;
in
{
  flake = {
    inherit colors colorsNoHash font;

    nixosModules.theme = { lib, ... }: {
      options.theme = {
        font = {
          name           = lib.mkOption { type = lib.types.str;   default = font.name; };
          alacritty_size = lib.mkOption { type = lib.types.float; default = font.alacritty_size; };
          polybar_size   = lib.mkOption { type = lib.types.int;   default = font.polybar_size; };
          rofi_size      = lib.mkOption { type = lib.types.int;   default = font.rofi_size; };
        };
        colors = lib.mkOption {
          type    = lib.types.attrsOf lib.types.str;
          default = colors;
        };
      };
    };
  };
}