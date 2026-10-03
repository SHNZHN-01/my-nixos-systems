{ self, ... }: {
  flake.nixosModules.desktop =
    {
      ...
    }:
    {
      imports = [
        self.nixosModules.boot
        self.nixosModules.user
        self.nixosModules.localetime
        self.nixosModules.nix
        self.nixosModules.preferences
        self.nixosModules.theme
        self.nixosModules.console
        self.nixosModules.gc
        self.nixosModules.common
        self.nixosModules.xserver
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.theming
        self.nixosModules.shell
        self.nixosModules.firefox
        self.nixosModules.fcitx5
        self.nixosModules.formatter
        self.nixosModules.ui
        self.nixosModules.cli
        self.nixosModules.dev
        self.nixosModules.ai
        self.nixosModules.security
        self.nixosModules.apps
        self.nixosModules.docker
      ];
    };
}
