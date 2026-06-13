{ self, inputs, ... }: {
    flake.nixosModules.testing = { config, lib, pkgs, modulesPath, ... }: {
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

        #nixpkgs.hostPlatform = pkgs.system;
        nixpkgs.hostPlatform = "x86_64-linux";
    };
}
