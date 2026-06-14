{ self, inputs, ... }: {
    flake.nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            self.nixosModules.pc
        ];
    };

    flake.nixosModules.pc = { pkgs, lib, config, ... }: {
        imports = [ 
            self.nixosModules.common
            self.nixosModules.desktop

            inputs.disko.nixosModules.disko
            self.diskoConfigurations.pc
        ];

        networking.hostName = "computer";

        boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        boot.initrd.luks.devices = {
            "crypted-nixos" = {
                allowDiscards = true;
                preLVM = true;
            };

            "crypted-storage" = {
                allowDiscards = true;
                preLVM = true;
                keyFile = "/crypto_keyfile.bin";
            };

            "crypted-vms" = {
                allowDiscards = true;
                preLVM = true;
                keyFile = "/crypto_keyfile.bin";
            };
        };

        boot.initrd.secrets = {
            "/crypto_keyfile.bin" = "/secrets/crypto_keyfile.bin";
        };


        hardware.cpu.intel.updateMicrocode = true;

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.05";
    };
}
