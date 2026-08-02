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
        Xft.dpi: 120 
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
        /Windows 11 (gaming)
            comment: Windows Gaming
            protocol: efi
            path: guid(1e4f7eb6-c8ae-4fbe-a645-4b53c0e4d267):/EFI/Microsoft/Boot/bootmgfw.efi
        /Windows 11 (infosec)
            comment: Windows Infosec
            protocol: efi
            path: guid(1a750d7e-f696-44f2-808e-e3b2cc469faf):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

      systemd.tmpfiles.rules = [
        "d /vms 0755 ${username} ${username} - -"
      ];

      services.xserver.displayManager.startx.extraCommands = ''
        xrandr --output DP-2 --mode 2560x1440 --rotate normal --primary --rate 240.00
        xrdb -merge ${xresources}
      '';

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.includeDefaultModules = true;
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
