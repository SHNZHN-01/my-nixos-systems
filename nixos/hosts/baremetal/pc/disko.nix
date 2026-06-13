{
  flake.diskoConfigurations.pc = {
      disko.devices = {
        disk.main = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:00:0d.0-ata-1";
          content = {
            # GPT partition table for this device 
            type = "gpt";
            partitions = {
              # EFI system partition
              esp = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              # LVM partition
              primary = {
                size = "100%"; # fill up the rest
                content = {
                  type = "lvm_pv"; # pvcreate
                  vg = "vg1";
                };
              };
            };
          };
          # vgcreate
          lvm_vg = { 
            # /dev/vg1
            vg1 = {
              type = "lvm_vg";
              # lvcreaste
              lvs = {
                # /dev/vg1/swap
                swap = {
                  size = "16G";
                  content = {
                    type = "swap";
                  };
                };
                # /dev/vg1/nix
                nix = {
                  size = "50G";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                    ];
                  };
                };

                # /dev/vg1/root
                root = {
                  size = "100%FREE";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                    mountOptions = [
                      "defaults"
                    ];
                  };
                };
              };
            };

          };
        };
      };
  };
}