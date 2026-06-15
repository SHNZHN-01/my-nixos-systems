{ self, inputs, ... }: {
  flake.nixosModules.desktop = { config, pkgs, ... }:
  let
    wrapped = self.packages.${pkgs.system};
    alacritty = self.lib.makeAlacritty { inherit pkgs; font = config.theme.font; colors = config.theme.colors; };
    polybar   = self.lib.makePolybar   { inherit pkgs; font = config.theme.font; colors = config.theme.colors; };
    rofi      = self.lib.makeRofi      { inherit pkgs; font = config.theme.font; colors = config.theme.colors; };
    dircolors = pkgs.writeText "dircolors" ''
    COLORTERM ?*
    TERM Eterm
    TERM ansi
    TERM *color*
    TERM con[0-9]*x[0-9]*
    TERM cons25
    TERM console
    TERM cygwin
    TERM *direct*
    TERM dtterm
    TERM gnome
    TERM hurd
    TERM jfbterm
    TERM konsole
    TERM kterm
    TERM linux
    TERM linux-c
    TERM mlterm
    TERM putty
    TERM rxvt*
    TERM screen*
    TERM st
    TERM terminator
    TERM tmux*
    TERM vt100
    TERM xterm*
    RESET 0 # reset to "normal" color
    DIR 01;38;5;172 # directory
    LINK 01;36 # symbolic link. (If you set this to 'target' instead of a
    MULTIHARDLINK 00 # regular file with more than one link
    FIFO 40;33 # pipe
    SOCK 01;35 # socket
    DOOR 01;35 # door
    BLK 40;33;01 # block device driver
    CHR 40;33;01 # character device driver
    ORPHAN 40;31;01 # symlink to nonexistent file, or non-stat'able file ...
    MISSING 00 # ... and the files they point to
    SETUID 37;41 # file that is setuid (u+s)
    SETGID 30;43 # file that is setgid (g+s)
    CAPABILITY 00 # file with capability (very expensive to lookup)
    STICKY_OTHER_WRITABLE 30;42 # dir that is sticky and other-writable (+t,o+w)
    OTHER_WRITABLE 34;42 # dir that is other-writable (o+w) and not sticky
    STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable
    EXEC 01;32
    .7z 01;31
    .ace 01;31
    .alz 01;31
    .apk 01;31
    .arc 01;31
    .arj 01;31
    .bz 01;31
    .bz2 01;31
    .cab 01;31
    .cpio 01;31
    .crate 01;31
    .deb 01;31
    .drpm 01;31
    .dwm 01;31
    .dz 01;31
    .ear 01;31
    .egg 01;31
    .esd 01;31
    .gz 01;31
    .jar 01;31
    .lha 01;31
    .lrz 01;31
    .lz 01;31
    .lz4 01;31
    .lzh 01;31
    .lzma 01;31
    .lzo 01;31
    .pyz 01;31
    .rar 01;31
    .rpm 01;31
    .rz 01;31
    .sar 01;31
    .swm 01;31
    .t7z 01;31
    .tar 01;31
    .taz 01;31
    .tbz 01;31
    .tbz2 01;31
    .tgz 01;31
    .tlz 01;31
    .txz 01;31
    .tz 01;31
    .tzo 01;31
    .tzst 01;31
    .udeb 01;31
    .war 01;31
    .whl 01;31
    .wim 01;31
    .xz 01;31
    .z 01;31
    .zip 01;31
    .zoo 01;31
    .zst 01;31
    .avif 01;35
    .jpg 01;35
    .jpeg 01;35
    .mjpg 01;35
    .mjpeg 01;35
    .gif 01;35
    .bmp 01;35
    .pbm 01;35
    .pgm 01;35
    .ppm 01;35
    .tga 01;35
    .xbm 01;35
    .xpm 01;35
    .tif 01;35
    .tiff 01;35
    .png 01;35
    .svg 01;35
    .svgz 01;35
    .mng 01;35
    .pcx 01;35
    .mov 01;35
    .mpg 01;35
    .mpeg 01;35
    .m2v 01;35
    .mkv 01;35
    .webm 01;35
    .webp 01;35
    .ogm 01;35
    .mp4 01;35
    .m4v 01;35
    .mp4v 01;35
    .vob 01;35
    .qt 01;35
    .nuv 01;35
    .wmv 01;35
    .asf 01;35
    .rm 01;35
    .rmvb 01;35
    .flc 01;35
    .avi 01;35
    .fli 01;35
    .flv 01;35
    .gl 01;35
    .dl 01;35
    .xcf 01;35
    .xwd 01;35
    .yuv 01;35
    .cgm 01;35
    .emf 01;35
    .ogv 01;35
    .ogx 01;35
    .aac 00;36
    .au 00;36
    .flac 00;36
    .m4a 00;36
    .mid 00;36
    .midi 00;36
    .mka 00;36
    .mp3 00;36
    .mpc 00;36
    .ogg 00;36
    .ra 00;36
    .wav 00;36
    .oga 00;36
    .opus 00;36
    .spx 00;36
    .xspf 00;36
    *~ 38;5;243
    *# 38;5;243
    .bak 38;5;243
    .crdownload 38;5;243
    .dpkg-dist 38;5;243
    .dpkg-new 38;5;243
    .dpkg-old 38;5;243
    .dpkg-tmp 38;5;243
    .old 38;5;243
    .orig 38;5;243
    .part 38;5;243
    .rej 38;5;243
    .rpmnew 38;5;243
    .rpmorig 38;5;243
    .rpmsave 38;5;243
    .swp 38;5;243
    .tmp 38;5;243
    .ucf-dist 38;5;243
    .ucf-new 38;5;243
    .ucf-old 38;5;243
    '';
  in {
    imports = [
        self.nixosModules.keybinds
        self.nixosModules.firefox
        self.nixosModules.fcitx5
        self.nixosModules.formatter
    ];

    programs.keybinds.enable = true;

    services.unclutter = {
        enable = true;
        timeout = 5;
        keystroke = true;
    };
    services.xserver.enable = true;
    services.xserver.autorun = false;
    services.xserver.xkb.options = "compose:ralt";
    services.xserver.windowManager.i3 = {
        enable = true;
        package = wrapped.i3; 
        extraPackages = with pkgs; [
            i3lock
        ];
    };
    services.xserver.displayManager.startx = {
        enable = true;
        generateScript = true;
        extraCommands = ''
          polybar main 2>&1 | tee -a /tmp/polybar.log & disown
        '';
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.terminess-ttf
        fixedsys-excelsior
        noto-fonts-cjk-sans    # makes Chinese render everywhere via fallback (essential)
        noto-fonts-cjk-serif   # optional, for serif/prose
        sarasa-gothic          # monospace CJK for terminal + editor
    ];

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    environment.systemPackages = [
      (pkgs.catppuccin-kvantum.override { accent = "blue"; variant = "mocha"; })
    ];

    environment.sessionVariables.GTK_THEME = "Adwaita:dark";

    environment.etc."xdg/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha-Blue
    '';

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [{
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    }];

    # TODO: move some of the packages here into different .nix files
    # TODO: add binary ninja
    # TODO: handle bat theme
    users.users.${config.username}.packages = with pkgs; [
        xev
        xinit
        btop
        git
        ripgrep
        wiremix
        bat
        bat-extras.batman
        dtach
        ueberzugpp
        zathura
        dunst
        eza
        gh
        gdb
        xclip
        veracrypt
        keepassxc
        flameshot
        gcc
        clang
        gnumake
        python3
        discord
        spotify
        playerctl
        aflplusplus
        # python313Packages.setuptools
        # python313Packages.setuptools-scm
        # python313Packages.setuptools-rust
        # python313Packages.angr
        # python313Packages.binwalk3
        # binwalk
        # owasp dependency check
        # owasp dep scan
        # jd-gui
        burpsuite
        wireshark
        tshark
        termshark
        tcpdump
        dnsutils
        hashcat
        hcxdumptool
        aircrack-ng
        pwntools
        android-studio
        android-tools
        apktool
        jadx
        objection
        trufflehog
        trivy
        gitleaks
        cve-bin-tool
        nuclei
        sqlite
        binsider
        sqlmap
        nmap
        semgrep
        codeql
        frida-tools
        go
        docker
        qemu_full
        # binaryninja-free
        virtualbox
        firefox
        google-chrome
        ungoogled-chromium
    ] ++ [ alacritty polybar rofi ] ++ [
      inputs.neovim-shnzhn.packages.${pkgs.stdenv.hostPlatform.system}.neovim-shnzhn
      # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    nixpkgs.config.android_sdk.accept_license = true;

    environment.variables = {
        MAKEFLAGS="-j$(nproc)";
    };

    environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec startx
    fi
    '';

    environment.shellAliases = {
      chmod   = "chmod -v";
      chgrp   = "chgrp -v";
      ln      = "ln -v";
      install = "install -v";
      rm      = "rm -v";
      cp      = "cp -v";
      mkdir   = "mkdir -v";
      mv      = "mv -v";
      cat     = "bat --color=always";
      man     = "batman --color=always";
      bathelp = "bat --plain --language=help";
      ls      = "eza -g --color=auto";
      gdb     = "gdb -q";
      grep    = "grep --color=auto";
      fgrep   = "fgrep --color=auto";
      egrep   = "egrep --color=auto";
      readelf = "readelf -W";
      objdump = "objdump -M intel";
      gh_login   = "gh auth login -p https -w";
      gh_logout  = "gh auth logout";
      gh_status  = "gh auth status";
      list_ports = "sudo ss -antpu | grep -Ev 'spotify|Discord|firefox'";
      ncmpc      = "ncmpc --host=127.0.0.1 --port=6600 --no-colors";
    };

    programs.bash.interactiveShellInit = ''
      eval "$(dircolors -b ${dircolors})"

      help() {
        "$@" --help 2>&1 | bat --plain --language=help
      }

      fastgit() {
        git add . && git commit -m "$@" && git push
      }

      veracrypt_mount() {
        sudo mkdir -p /mnt/veracrypt1
        sudo cryptsetup --type tcrypt open /dev/sda veracrypt1
        sudo mount /dev/mapper/veracrypt1 /mnt/veracrypt1
      }

      veracrypt_unmount() {
        sudo umount /mnt/veracrypt1
        sudo cryptsetup --type tcrypt close /dev/mapper/veracrypt1
      }

      hex_to_dec() { printf "%d\n" "$@"; }
      dec_to_hex() { printf "%x\n" "$@"; }

      copy_file() { xclip -sel c < "$@"; }

      gdb_gef() { gdb -q -ex init-gef "$@"; }
    '';

    programs.bash.promptInit = ''
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
      }

      GREEN="\[$(tput setaf 02)\]"
      MAGENTA="\[$(tput setaf 05)\]"
      CYAN="\[$(tput setaf 06)\]"
      RESET="\[\e[0m\]"

      PS0="''${RESET}"
      PS1="''${GREEN}\u@\h ''${CYAN}\w''${GREEN} ''${MAGENTA}\$(parse_git_branch)''${RESET}\$ "
    '';
  };
}
