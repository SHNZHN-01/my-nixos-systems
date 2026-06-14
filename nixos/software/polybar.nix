{ self, ... }: {
  flake.lib.makePolybar = { pkgs, font, colors }:
    self.wrappers.polybar.wrap {
      inherit pkgs;
      settings = {
        colors = {
          background     = colors.base00;
          background-alt = colors.base08;
          foreground     = colors.base07;
          primary        = colors.base02;
          secondary      = colors.base06;
          alert          = colors.base01;
          warning        = colors.base03;
          disabled       = colors.base08;
          dimmed         = colors.base08;
        };

        "bar/main" = {
          width  = "100%";
          height = "20pt";
          radius = 0;
          top    = false;
          bottom = true;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size          = "0pt";
          border-top-size    = "2pt";
          border-bottom-size = "0pt";
          border-right-size  = "0pt";
          border-left-size   = "0pt";
          border-color       = "\${colors.foreground}";
          padding-left       = 0;
          padding-right      = 1;
          module-margin      = 1;
          separator          = "|";
          separator-foreground = "\${colors.dimmed}";
          font-0 = "${font.name}:pixelsize=${toString font.polybar_size}:antialias:true:style=Regular;2";
          modules-left   = "xworkspaces";
          modules-center = "";
          modules-right  = "home_filesystem nix_filesystem root_filesystem pulseaudio memory cpu eth dunst date";
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

        "module/root_filesystem" = {
          type     = "internal/fs";
          interval = 25;
          mount-0  = "/";
          label-mounted = "%{F#F0C674}%mountpoint%%{F-} %used% of %total%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "\${colors.disabled}";
        };

        "module/nix_filesystem" = {
          type     = "internal/fs";
          interval = 25;
          mount-0  = "/nix";
          label-mounted = "%{F#F0C674}%mountpoint%%{F-} %used% of %total%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "\${colors.disabled}";
        };

        "module/home_filesystem" = {
          type     = "internal/fs";
          interval = 25;
          mount-0  = "/home";
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
          format = "<label>";
          format-prefix            = "";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%gb_used% / %gb_total%";
        };

        "module/cpu" = {
          type     = "internal/cpu";
          interval = 2;
          format-prefix            = "CPU ";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%percentage:3%%";
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

        # "module/dunst" = {
        #     type = "custom/ipc";
        #     initial = 1;
        #     format-foreground = "\${colors.foreground}";
        #
        #     hook-0 = "echo \"%{A1:dunstctl set-paused true && polybar-msg hook dunst 2:}%{A}\" &";
        #     hook-1 = "echo \"%{A1:dunstctl set-paused false && polybar-msg hook dunst 1:}%{A}\" &";
        # };

        settings = {
          screenchange-reload = true;
          pseudo-transparency = true;
        };
      };
    };
}
