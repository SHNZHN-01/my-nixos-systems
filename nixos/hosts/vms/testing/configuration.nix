{ self, inputs, ... }: {
    flake.nixosConfigurations.testing = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            self.nixosModules.testing
        ];
    };

    flake.nixosModules.testing = { pkgs, lib, config, ... }: {
        imports = [ 
            self.nixosModules.common
            self.nixosModules.desktop
            self.nixosModules.virtualized

            inputs.disko.nixosModules.disko
            self.diskoConfigurations.testing
        ];

        networking.hostName = "testing";

        # TODO: change this to a lib.mkIf inside boot.nix
        # if here we set some property "isVm" to true
        # then this gets built in boot.nix
        boot.initrd.availableKernelModules = [
            # VirtualBox (SATA/AHCI, IDE) + CD
            "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod"
            # QEMU/KVM + VirtualBox-virtio (virtio devices)
            "virtio_pci" "virtio_blk" "virtio_scsi" "virtio_net" "virtio_balloon"
            "9p" "9pnet_virtio"
            # generic SCSI / NVMe
            "xhci_pci" "nvme" "sym53c8xx"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.05";
    };
}
