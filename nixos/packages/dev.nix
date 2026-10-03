_: {
  flake.nixosModules.dev =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = with pkgs; [
        cmake
        gcc
        clang
        clang-tools
        gnumake
        python3
        go
        sqlite
        nasm
        vscode
        android-studio
        lua-language-server
        pyright
        ruff
        bootdev-cli
      ];

      nixpkgs.config.android_sdk.accept_license = true;
    };
}
