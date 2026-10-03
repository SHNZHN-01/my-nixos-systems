{ self, ... }: {
  flake.nixosModules.baremetal =
    { ... }:
    {
      imports = [
        self.nixosModules.qemu-host
        self.nixosModules.networking
        self.nixosModules.dnscrypt
        self.nixosModules.ssh-configs
      ];
    };
}
