{ self, ... }: {
  perSystem =
    { pkgs, ... }:
    let
      colors = self.colors;
      font = self.font;
    in
    {
      wrappers.packages.i3 = true;
      packages.i3 = self.wrappers.i3.wrap {
        inherit pkgs;
        configContent = ''
          set $mod Mod4

          bindsym $mod+b exec --no-startup-id polybar-msg cmd toggle

          font pango:${font.name} 0 

          floating_modifier $mod

          bindsym $mod+Return exec alacritty

          bindsym $mod+Shift+m exec --no-startup-id keybinds

          bindsym $mod+Shift+q kill

          bindsym $mod+r exec --no-startup-id rofi -show drun 
          bindsym $mod+Shift+r exec --no-startup-id rofi -show combi 

          bindsym XF86AudioRaiseVolume exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+ && $refresh_i3status
          bindsym XF86AudioLowerVolume exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%- && $refresh_i3status
          bindsym XF86AudioMute exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && $refresh_i3status
          bindsym XF86AudioMicMute exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && $refresh_i3status
          bindsym XF86AudioPlay exec --no-startup-id playerctl play-pause
          bindsym XF86AudioNext exec --no-startup-id playerctl next 
          bindsym XF86AudioPrev exec --no-startup-id playerctl previous

          focus_wrapping workspace

          for_window [class="floatmixer"] floating enable, resize set 900 550, move position center
          bindsym $mod+Shift+v exec --no-startup-id alacritty --class floatmixer -e wiremix

          # Cycle forwards through tabs on the current monitor
          bindsym $mod+comma focus right, focus parent, focus child

          # Cycle backwards through tabs on the current monitor
          bindsym $mod+period focus left, focus parent, focus child

          # change focus
          bindsym $mod+h focus left
          bindsym $mod+j focus up
          bindsym $mod+k focus down
          bindsym $mod+l focus right

          # move focused window
          bindsym $mod+Shift+h move left
          bindsym $mod+Shift+j move up
          bindsym $mod+Shift+k move down
          bindsym $mod+Shift+l move right

          # split in horizontal orientation
          bindsym $mod+Alt+h split h

          # split in vertical orientation
          bindsym $mod+Alt+v split v

          # enter fullscreen mode for the focused container
          bindsym $mod+Ctrl+f fullscreen toggle

          # change container layout (stacked, tabbed, toggle split)
          bindsym $mod+s layout stacking
          bindsym $mod+w layout tabbed
          bindsym $mod+e layout toggle split

          # toggle tiling / floating
          bindsym $mod+Shift+space floating toggle

          # change focus between tiling / floating windows
          bindsym $mod+space focus mode_toggle

          # focus the parent container
          bindsym $mod+a focus parent

          # Define names for default workspaces for which we configure key bindings later on.
          # We use variables to avoid repeating the names in multiple places.
          set $ws1 "1"
          set $ws2 "2"
          set $ws3 "3"
          set $ws4 "4"
          set $ws5 "5"
          set $ws6 "6"
          set $ws7 "7"
          set $ws8 "8"
          set $ws9 "9"

          # switch to workspace
          bindsym $mod+1 workspace number $ws1
          bindsym $mod+2 workspace number $ws2
          bindsym $mod+3 workspace number $ws3
          bindsym $mod+4 workspace number $ws4
          bindsym $mod+5 workspace number $ws5
          bindsym $mod+6 workspace number $ws6
          bindsym $mod+7 workspace number $ws7
          bindsym $mod+8 workspace number $ws8
          bindsym $mod+9 workspace number $ws9

          # move focused container to workspace
          bindsym $mod+Shift+1 move container to workspace number $ws1
          bindsym $mod+Shift+2 move container to workspace number $ws2
          bindsym $mod+Shift+3 move container to workspace number $ws3
          bindsym $mod+Shift+4 move container to workspace number $ws4
          bindsym $mod+Shift+5 move container to workspace number $ws5
          bindsym $mod+Shift+6 move container to workspace number $ws6
          bindsym $mod+Shift+7 move container to workspace number $ws7
          bindsym $mod+Shift+8 move container to workspace number $ws8
          bindsym $mod+Shift+9 move container to workspace number $ws9

          bindsym $mod+Ctrl+h move workspace to output left
          bindsym $mod+Ctrl+l move workspace to output right
          bindsym $mod+Ctrl+j move workspace to output primary 

          bindsym $mod+Alt+c reload
          bindsym $mod+Alt+r restart

          bindsym $mod+Shift+e mode "logout"
          mode "logout" {
            bindsym l exec i3lock --ignore-empty-password -t -p $HOME/pictures/lockscreen.png 2>/dev/null; mode "default"
            bindsym e exec "i3-msg exit"
            bindsym Escape mode "default"
            bindsym Return mode "default"
          }

          bindsym $mod+Ctrl+r mode "resize"
          mode "resize" {
                  bindsym h resize shrink width 5 px or 5 ppt
                  bindsym k resize grow height 5 px or 5 ppt
                  bindsym j resize shrink height 5 px or 5 ppt
                  bindsym l resize grow width 5 px or 5 ppt

                  bindsym Return mode "default"
                  bindsym Escape mode "default"
          }

          bindsym $mod+Escape exec flameshot gui -p $HOME/pictures/screenshots
          bindsym $mod+Shift+Escape exec flameshot gui

          exec --no-startup-id i3-msg "workspace 9; layout tabbed; exec discord; exec keepassxc; exec veracrypt; exec whatsapp-electron; exec Telegram; exec spotify"

          default_border pixel 1
          default_floating_border pixel 1
          hide_edge_borders both 

          client.focused ${colors.base00} ${colors.base00} ${colors.base00} ${colors.base00} ${colors.base07}
          client.unfocused ${colors.base00} ${colors.base00} ${colors.base00} ${colors.base00} ${colors.base07}
        '';
      };
    };
}
