{ self, inputs, ... }: {
  flake.nixosConfigurations.computer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.computer
    ];
  };

  flake.nixosModules.computer =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      xresources = pkgs.writeText "Xresources" ''
        Xft.dpi: 96
      '';
    in
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.desktop

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.computer
      ];

      networking.hostName = "computer";

      services.xserver.displayManager.startx.extraCommands = ''
        xrandr --output HDMI-0 --mode 1920x1080 --rotate left --pos 0x0 --output DP-4 --mode 1920x1080 --rotate normal --primary --pos 1080x0
        xrdb -merge ${xresources}
      '';

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-intel" ];
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

      hardware = {
        cpu.intel.updateMicrocode = true;
        graphics.enable = true;
        nvidia.open = true;
      };
      services.xserver.videoDrivers = [ "nvidia" ];

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
    };
}
