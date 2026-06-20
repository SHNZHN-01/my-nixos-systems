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

      paths = [
        "/vms"
        "/data/blender"
        "/data/games"
        "/data/video"
        "/data/audio"
      ];

      escape = path: builtins.replaceStrings [ "/" ] [ "-" ] (lib.removePrefix "/" path);
    in
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.desktop
        self.nixosModules.gaming

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.computer
      ];

      networking.hostName = "computer";
      boot.loader.limine.extraEntries = ''
        /Windows
            comment: Windows
            protocol: efi
            path: uuid(XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

      systemd.tmpfiles.rules = [
        "d /vms 0755 ${username} ${username} - -"
        "d /data/audio 0755 ${username} ${username} - -"
        "d /data/video 0755 ${username} ${username} - -"
        "d /data/games 0755 ${username} ${username} - -"
        "d /data/blender 0755 ${username} ${username} - -"
      ];
      # systemd.services = builtins.listToAttrs (
      #   map (
      #     path:
      #     let
      #       mountUnit = "${escape path}.mount";
      #     in
      #     {
      #       name = "fix-owner-${escape path}";
      #       value = {
      #         after = [ mountUnit ];
      #         wantedBy = [ mountUnit ];
      #         unitConfig.RequiresMountsFor = path;
      #         serviceConfig = {
      #           Type = "oneshot";
      #           ExecStart = "${pkgs.coreutils}/bin/chown ${username}:${username} ${path}";
      #         };
      #       };
      #     }
      #   ) paths
      # );

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
