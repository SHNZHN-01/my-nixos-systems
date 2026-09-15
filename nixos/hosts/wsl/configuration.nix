{ self, inputs, ... }: {
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.nix
      self.nixosModules.wsl
    ];
  };

  flake.nixosModules.wsl =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.NixOS-WSL.nixosModules.wsl
      ];

      wsl.enable = true;
      wsl.defaultUser = "nixos";
      users.users.root.hashedPassword = "!";

      programs.firefox.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          fd
          fzf
          git
          ripgrep
          bat
          bat-extras.batman
          eza
          gh
          cmake
          gcc
          clang
          clang-tools
          gnumake
          python3
          lua-language-server
          opencode
          lsof
          bootdev-cli
          uv
          go
        ]
        ++ [
          inputs.neovim-shnzhn.packages.${pkgs.stdenv.hostPlatform.system}.neovim-shnzhn
        ];

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1 — by far the most important
        zlib
        zstd
        openssl
        curl
        libffi
        sqlite
        bzip2
        xz
        ncurses
        readline
        glib
        libxml2
        libxslt
        util-linux # libuuid
        stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1 — by far the most important
        zlib
        zstd
        openssl
        curl
        libffi
        sqlite
        bzip2
        xz
        ncurses
        readline
        glib
        libxml2
        libxslt
        util-linux # libuuid

        # SDL/pygame: dlopen'd at runtime for video, input, and audio
        libx11
        libxext
        libxcursor
        libxi
        libxfixes
        libxrandr
        libxscrnsaver
        libxkbcommon
        wayland
        libGL
        alsa-lib
        libpulseaudio
      ];

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

      environment.shellAliases = {
        chmod = "chmod -v";
        chgrp = "chgrp -v";
        ln = "ln -v";
        install = "install -v";
        rm = "rm -v";
        cp = "cp -v";
        mkdir = "mkdir -v";
        mv = "mv -v";
        cat = "bat --color=always";
        man = "batman --color=always";
        bathelp = "bat --plain --language=help";
        ls = "eza -g --color=auto";
        gdb = "gdb -q";
        grep = "grep --color=auto";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";
        readelf = "readelf -W";
        objdump = "objdump -M intel";
      };

      system.stateVersion = "26.05";
    };
}
