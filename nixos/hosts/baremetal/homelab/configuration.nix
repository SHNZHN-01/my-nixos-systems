{ self, inputs, ... }: {
  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.homelab
    ];
  };
  flake.nixosModules.homelab =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.boot
        self.nixosModules.user
        self.nixosModules.localetime
        self.nixosModules.nix
        self.nixosModules.preferences
        self.nixosModules.gc
        self.nixosModules.common
        self.nixosModules.networking
        self.nixosModules.ssh-server
        self.nixosModules.cpu-amd
        self.nixosModules.docker

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.homelab
      ];

      hostname = "homelab";

      networking = {
        nameservers = [ "1.1.1.1" ];
        firewall = {
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
          extraInputRules = ''
            ip saddr 10.10.30.0/24 tcp dport 22 accept comment "ssh from management vlan"
          '';
        };
      };

      security.tpm2.enable = true;

      boot = {
        initrd = {
          systemd.enable = true;
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "usb_storage"
            "sd_mod"
            "tpm_crb"
            "tpm_tis"
          ];
          kernelModules = [ ];
          luks.devices.crypted-homelab.crypttabExtraOpts = [
            "tpm2-device=auto"
            "tpm2-measure-pcr=yes"
          ];
        };
        extraModulePackages = [ ];
      };

      # storage disk: unlocked in stage 2 with a keyfile on the encrypted root
      environment.etc."crypttab".text = ''
        crypted-homelab-storage /dev/disk/by-partlabel/disk-sda-data /var/lib/luks/storage.key discard,nofail
      '';
      fileSystems."/storage".options = [ "nofail" ];

      systemd.services.tpm2-luks-enroll = {
        description = "Enroll TPM2 for crypted-homelab once Secure Boot is enforcing";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        unitConfig.ConditionPathExists = "/var/lib/luks/enroll.key";
        serviceConfig.Type = "oneshot";
        path = [
          config.systemd.package
          pkgs.cryptsetup
          pkgs.coreutils
          pkgs.gawk
        ];
        script = ''
          set -eu
          ROOT=/dev/disk/by-partlabel/disk-nvme0n1-root
          KEY=/var/lib/luks/enroll.key
          EFIVAR=/sys/firmware/efi/efivars
          GUID=8be4df61-93ca-11d2-aa0d-00e098032b8c

          sb=$(od -An -t u1 "$EFIVAR/SecureBoot-$GUID" | awk '{print $NF}')
          sm=$(od -An -t u1 "$EFIVAR/SetupMode-$GUID" | awk '{print $NF}')
          if [ "$sb" != 1 ] || [ "$sm" != 0 ]; then
            echo "Secure Boot not enforcing yet; will retry next boot"
            exit 0
          fi

          systemd-cryptenroll "$ROOT" \
            --unlock-key-file="$KEY" \
            --tpm2-device=auto \
            --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000

          cryptsetup luksRemoveKey "$ROOT" "$KEY"
          rm -f "$KEY"
          echo "TPM2 enrolled; enrollment key removed"
        '';
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
    };

}
