{ self, inputs, ... }: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.laptop
    ];
  };

  flake.nixosModules.laptop = { ... }: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.baremetal
      self.nixosModules.cpu-amd

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.laptop
    ];

    hostname = "laptop";

    theme.font = {
      alacritty_size = 13.5;
      polybar_size = 10;
      rofi_size = 13;
    };

    boot = {
      initrd = {
        systemd.enable = true;
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ "dm-snapshot" ];
        luks = {
          devices = {
            crypted-laptop = {
              preLVM = true;
              allowDiscards = true;
            };
          };
        };
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";

  };

}
