{ self, inputs, ... }: {
  flake.nixosConfigurations.testing = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.testing
    ];
  };

  flake.nixosModules.testing = { ... }: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.qemu-guest
      self.nixosModules.networking

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.testing
    ];

    hostname = "testing";

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
