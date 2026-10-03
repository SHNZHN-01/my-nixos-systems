{ self, inputs, ... }: {
  flake.nixosConfigurations.computer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.computer
    ];
  };

  flake.nixosModules.computer =
    { config, ... }:
    let
      inherit (config) username;
    in
    {
      imports = [
        self.nixosModules.desktop
        self.nixosModules.baremetal
        self.nixosModules.cpu-intel
        self.nixosModules.gaming

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.computer
      ];

      hostname = "computer";

      security.tpm2.enable = true;

      boot = {
        extraModulePackages = [ ];
        initrd = {
          systemd.enable = true;
          availableKernelModules = [
            "xhci_pci"
            "ehci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "sd_mod"
          ];
          includeDefaultModules = true;
          kernelModules = [ "dm-snapshot" ];
        };
        loader = {
          limine = {
            extraEntries = ''
              /Windows 11 (infosec)
                  comment: Windows Infosec
                  protocol: efi
                  path: guid(1a750d7e-f696-44f2-808e-e3b2cc469faf):/EFI/Microsoft/Boot/bootmgfw.efi
            '';
          };
        };
      };

      systemd.tmpfiles.rules = [
        "z /storage 0755 ${username} ${username} - -"
        "z /vms 0755 ${username} ${username} - -"
      ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia.open = true;
      };

      services = {
        xserver = {
          displayManager = {
            startx = {
              extraCommands = ''
                xrandr --output DP-2 --mode 2560x1440 --rotate normal --primary --rate 240.00
              '';
            };
          };
          videoDrivers = [ "nvidia" ];
        };
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
    };
}
