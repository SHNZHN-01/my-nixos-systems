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

        storage1 = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:00:17.0-ata-4";
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-storage-1";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "vg_storage";
                  };
                };
              };
            };
          };
        };

        storage2 = {
          type = "disk";
          device = "/dev/disk/by-path/pci-0000:00:17.0-ata-6";
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-storage-2";
                  settings = {
                    allowDiscards = true;
                  };
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
