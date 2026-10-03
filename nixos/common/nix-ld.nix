_: {
  flake.nixosModules.nix-ld = { pkgs, ... }: {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
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
        util-linux

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
    };
  };
}
