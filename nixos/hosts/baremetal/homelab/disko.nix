{
  flake.diskoConfigurations.homelab = {
    disko.devices = {
      disk = {

        nvme0n1 = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:03:00.0-nvme-1";
          content = {
            type = "gpt";
            partitions = {
              esp = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-homelab";
                  settings.allowDiscards = true;
                  additionalKeyFiles = [ "/tmp/enroll.key" ];
                  enrollRecovery = true; # prints a recovery key + QR during install
                  content = {
                    type = "lvm_pv";
                    vg = "vg_homelab";
                  };
                };
              };
            };
          };
        };

        sda = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:05:00.1-ata-1";
          content = {
            type = "gpt";
            partitions = {
              data = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-homelab-storage";
                  initrdUnlock = false;
                  settings.allowDiscards = true;
                  additionalKeyFiles = [ "/tmp/storage.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "vg_storage";
                  };
                };
              };
            };
          };
        };

      };

      lvm_vg = {
        vg_homelab = {
          type = "lvm_vg";
          lvs = {
            lv_swap = {
              size = "16G";
              content = {
                type = "swap";
              };
            };

            lv_root = {
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };

        vg_storage = {
          type = "lvm_vg";
          lvs = {
            lv_storage = {
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/storage";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}
