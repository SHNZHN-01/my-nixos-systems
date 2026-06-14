{ self, inputs, ... }: {
    flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            self.nixosModules.laptop
        ];
    };

    flake.nixosModules.laptop = { pkgs, lib, config, ... }: {
        imports = [ 
            self.nixosModules.common
            self.nixosModules.desktop

            inputs.disko.nixosModules.disko
            self.diskoConfigurations.laptop
        ];

        services.libinput.enable = true;

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ "dm-snapshot" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];


        boot.initrd.luks.devices = {
            "crypted-laptop" = {
                device = "/dev/nvme0n1p2";
                preLVM = true;
            };
        };

        hardware.cpu.amd.updateMicrocode = true;

        networking.hostName = "laptop";

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.05";
    };
}
