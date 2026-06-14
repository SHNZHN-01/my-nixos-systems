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

        theme.font.alacritty_size = 13.5;
        theme.font.polybar_size = 10;
        theme.font.rofi_size = 13;

        services.libinput.enable = true;

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ "dm-snapshot" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        boot.initrd.luks.devices = {
            "crypted-laptop" = {
                preLVM = true;
            };
        };

        hardware.cpu.amd.updateMicrocode = true;
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        networking.hostName = "laptop";

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.05";
    };
}
