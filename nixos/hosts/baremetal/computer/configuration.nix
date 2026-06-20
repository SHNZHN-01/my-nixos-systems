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
      username = config.username;

      xresources = pkgs.writeText "Xresources" ''
        Xft.dpi: 96
      '';

      escape = path: builtins.replaceStrings [ "/" ] [ "-" ] (lib.removePrefix "/" path);
    in
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.desktop

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.computer
      ];

      networking.hostName = "computer";
      boot.loader.limine.extraEntries = ''
        /Windows 11
            comment: Reboot into Windows Boot Manager
            protocol: efi_boot_entry
            entry: Windows Boot Manager
      '';

      systemd.tmpfiles.rules = [
        "d /vms 0755 ${username} ${username} - -"
      ];

      services.xserver.displayManager.startx.extraCommands = ''
        xrandr --output HDMI-0 --mode 1920x1080 --rotate left --pos 0x0 --output DP-2 --mode 1920x1080 --rotate normal --primary --pos 1080x0
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
