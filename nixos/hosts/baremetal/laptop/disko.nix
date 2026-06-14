{
  flake.diskoConfigurations.laptop = {
    disko.devices = {
      disk = {

        nvme0n1 = {
          type   = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type       = "filesystem";
                  format     = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-laptop";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg   = "vg_laptop";
                  };
                };
              };
            };
          };
        };

      };

      lvm_vg = {
        vg_laptop = {
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
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}