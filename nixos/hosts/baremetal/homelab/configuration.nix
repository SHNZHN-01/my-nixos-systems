{ self, inputs, ... }: {
  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.homelab
    ];
  };

  flake.nixosModules.homelab =
    { ... }:
    {
      imports = [
        self.nixosModules.boot
        self.nixosModules.user
        self.nixosModules.localetime
        self.nixosModules.nix
        self.nixosModules.preferences
        self.nixosModules.gc
        self.nixosModules.common
        self.nixosModules.networking
        self.nixosModules.ssh-server
        self.nixosModules.cpu-amd
        self.nixosModules.docker
        self.nixosModules.networking

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.homelab
      ];

      hostname = "homelab";

      networking = {
        nameservers = [ "1.1.1.1" ];
        firewall = {
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
          extraInputRules = ''
            ip saddr 10.10.30.0/24 tcp dport 22 accept comment "ssh from management vlan"
          '';
        };
      };

      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        extraModulePackages = [ ];
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
    };
}
