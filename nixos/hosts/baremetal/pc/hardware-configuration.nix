{ self, inputs, ... }: {
    flake.nixosModules.pc = { config, lib, pkgs, modulesPath, ... }: {
        imports = [ ];

        boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
            device = "/dev/mapper/cryptroot";
            fsType = "ext4";
        };

        boot.initrd.luks.devices = {
            cryptroot = {
                device = "/dev/disk/by-uuid/fb5e7b9a-a3bd-46ee-9ab6-cb35c78032c6";
            };
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/9AB4-619C";
              fsType = "vfat";
              options = [ "fmask=0022" "dmask=0022" ];
        };

        swapDevices = [{
            device = "/dev/disk/by-partuuid/6ab44fd9-94b0-46d5-b16a-5c81ba27938e";
            randomEncryption.enable = true;
        }];

        nixpkgs.hostPlatform = "x86_64-linux";
    };
}
