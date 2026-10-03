_: {
  flake.nixosModules.nix = _: {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    # nixpkgs.config.allowUnfreePredicate =
    #   pkg:
    #   builtins.elem (lib.getName pkg) [
    #     "berkeley-mono.zip"
    #     "berkeley-mono"
    #     "vscode"
    #     "google-chrome"
    #     "discord"
    #     "spotify"
    #     "steam"
    #     "steam-unwrapped"
    #     "nvidia-x11"
    #     "nvidia-settings"
    #     "burpsuite"
    #     "codeql"
    #     "veracrypt"
    #     "android-studio"
    #     "binaryninja-free"
    #     "android-sdk-cmdline-tools"
    #     "android-sdk-platform-tools"
    #     "android-sdk-platforms"
    #     "android-sdk-build-tools"
    #     "platform-tools"
    #     "android-sdk-tools"
    #     "tools"
    #     "build-tools"
    #     "platforms"
    #     "cmake"
    #     "cmdline-tools"
    #   ];
  };
}
