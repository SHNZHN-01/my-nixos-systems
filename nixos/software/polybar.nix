{ self, ... }: {
  perSystem = { pkgs, ... }: let
    theme = self.colors;
    font = self.font;
  in {
    wrappers.packages.polybar = true;
    packages.polybar = self.wrappers.polybar.wrap {
      inherit pkgs;
      settings = {
        colors = {
          background     = theme.base00;
          background-alt = theme.base08;   # was referenced but undefined
          foreground     = theme.base07;
          primary        = theme.base02;
          secondary      = theme.base06;
          alert          = theme.base01;
          warning        = theme.base03;
          disabled       = theme.base08;
          dimmed         = theme.base08;
        };

        "bar/main" = {
          width  = "100%";
          height = "20pt";
          radius = 0;
          top    = true;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size          = "0pt";
          border-top-size    = "0pt";
          border-bottom-size = "2pt";
          border-right-size  = "0pt";
          border-left-size   = "0pt";
          border-color       = "\${colors.foreground}";
          padding-left       = 0;
          padding-right      = 1;
          module-margin      = 1;
          #separator            = "/";
          separator          = "|";
          separator-foreground = "\${colors.dimmed}";
          font-0 = "${font}:pixelsize=9:style=Medium;2";
          modules-left   = "xworkspaces";
          modules-center = "";
          modules-right  = "filesystem pulseaudio memory cpu eth date";
          cursor-click   = "pointer";
          cursor-scroll  = "ns-resize";
          enable-ipc     = true;
        };

        "module/xworkspaces" = {
          type = "internal/xworkspaces";
          label-active            = "%name%";
          label-active-background = "\${colors.background-alt}";
          label-active-underline  = "\${colors.foreground}";
          label-active-padding    = 1;
          label-occupied          = "%name%";
          label-occupied-padding  = 1;
          label-urgent            = "%name%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding    = 1;
          label-empty             = "%name%";
          label-empty-foreground  = "\${colors.disabled}";
          label-empty-padding     = 1;
        };

        "module/filesystem" = {
          type     = "internal/fs";
          interval = 25;
          mount-0  = "/";
          label-mounted = "%{F#F0C674}%mountpoint%%{F-} %used% of %total%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "\${colors.disabled}";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          format-volume-prefix            = "VOL ";
          format-volume-prefix-foreground = "\${colors.foreground}";
          format-volume = "<label-volume>";
          label-volume  = "%percentage%%";
          format-muted-prefix            = "MUTE ";
          format-muted-prefix-foreground = "\${colors.disabled}";
          label-muted            = "muted";
          label-muted-foreground = "\${colors.disabled}";
          click-right = "pavucontrol";
        };

        "module/memory" = {
          type     = "internal/memory";
          interval = 2;
          format-prefix            = "";
          format-prefix-foreground = "\${colors.foreground}";
        };

        "module/cpu" = {
          type     = "internal/cpu";
          interval = 2;
          format-prefix            = "CPU ";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%percentage:2%%";
        };

        "network-base" = {
          type     = "internal/network";
          interval = 5;
          format-connected    = "<label-connected>";
          format-disconnected = "<label-disconnected>";
          label-disconnected  = "%{F#F0C674}%ifname%%{F#707880} disconnected";
        };

        "module/wlan" = {
          "inherit"      = "network-base";
          interface-type = "wireless";
          label-connected     = "%{F#F0C674}%ifname%%{F-} %essid% %local_ip%";
          format-disconnected = "";
        };

        "module/eth" = {
          "inherit"      = "network-base";
          interface-type = "wired";
          label-connected     = "%{F#A3BE8C}%ifname%%{F-} %local_ip%";
          format-disconnected = "";
        };

        "module/date" = {
          type     = "internal/date";
          interval = 1;
          date     = "%H:%M %d-%m-%Y";
          format-prefix            = "";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%date%";
        };

        settings = {
          screenchange-reload   = true;
          pseudo-transparency   = true;
        };
      };
    };
  };
}