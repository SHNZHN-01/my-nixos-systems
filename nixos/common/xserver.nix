{ self, ... }: {
  flake.nixosModules.xserver =
    { pkgs, ... }:
    let
      wrapped = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        self.nixosModules.keybinds
      ];

      programs.keybinds.enable = true;

      services = {
        unclutter = {
          enable = true;
          timeout = 5;
          keystroke = true;
        };
        xserver = {
          enable = true;
          autorun = false;
          xkb.options = "compose:ralt";
          windowManager.i3 = {
            enable = true;
            package = wrapped.i3;
            extraPackages = with pkgs; [
              i3lock
            ];
          };
          displayManager.startx = {
            enable = true;
            generateScript = true;
            extraCommands = ''
              polybar main 2>&1 | tee -a /tmp/polybar.log & disown
            '';
          };
        };
        libinput = {
          enable = true;
          mouse = {
            accelProfile = "flat";
          };
        };
      };

      programs.solaar.enable = true;

      environment.loginShellInit = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
            exec startx
        fi
      '';
    };
}
