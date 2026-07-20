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
        ]
        ++ [
          inputs.neovim-shnzhn.packages.${pkgs.stdenv.hostPlatform.system}.neovim-shnzhn
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
