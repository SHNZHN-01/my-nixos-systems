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
        self.nixosModules.preferences
        self.nixosModules.ssh-configs
        self.nixosModules.shell
        self.nixosModules.cli
        self.nixosModules.dev
        self.nixosModules.ai
        self.nixosModules.neovim
        self.nixosModules.nix-ld
        self.nixosModules.docker
      ];

      username = "nixos";

      wsl.enable = true;
      wsl.defaultUser = "nixos";
      users.users.root.hashedPassword = "!";

      environment.systemPackages = with pkgs; [
        fd
        fzf
        uv
        nodejs
        ffmpeg
      ];

      system.stateVersion = "26.05";
    };
}
