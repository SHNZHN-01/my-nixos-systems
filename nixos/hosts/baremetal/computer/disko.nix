{
  flake.diskoConfigurations.computer = {
    disko.devices = {
      disk = {
        nixos = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:05:00.0-nvme-1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-nixos";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "vg_nixos";
                  };
                };
              };
            };
          };
        };
        vms = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1";
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-vms";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "vg_vms";
                  };
                };
              };
            };
          };
        };

      };

      lvm_vg = {

        vg_nixos = {
          type = "lvm_vg";
          lvs = {
            lv_root = {
              size = "65G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };

            lv_nix = {
              size = "200G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
                mountOptions = [ "noatime" ];
              };
            };

            lv_home = {
              # ~200G
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                mountOptions = [ "defaults" ];
              };
            };

            lv_swap = {
              size = "16G";
              content = {
                type = "swap";
              };
            };

          };
        };
        vg_vms = {
          type = "lvm_vg";
          lvs = {
            lv_vms = {
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/vms";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };

      };
    };
  };
}
