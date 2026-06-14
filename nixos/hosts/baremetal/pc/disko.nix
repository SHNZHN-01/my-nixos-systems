{
  flake.diskoConfigurations.pc = {
    disko.devices = {
      disk = {
        nixos = {
          type   = "disk";
          device = "/dev/disk/by-path/pci-0000:05:00.0-nvme-1";
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
                  name = "crypted-nixos";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg   = "vg_nixos";
                  };
                };
              };
            };
          };
        };

        storage = {
          type   = "disk";
          device = "/dev/disk/by-path/pci-0000:00:17.0-ata-4";
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted-storage";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg   = "vg_storage";
                  };
                };
              };
            };
          };
        };

        vms = {
          type   = "disk";
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
                    vg   = "vg_vms";
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
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };

            lv_nix = {
              size = "200G";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/nix";
                mountOptions = [ "noatime" ];
              };
            };

            lv_home = {
              # ~200G
              size = "100%FREE";
              content = {
                type       = "filesystem";
                format     = "ext4";
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

        vg_storage = {
          type = "lvm_vg";
          lvs = {
            lv_games = {
              size = "1500G";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/data/games";
                mountOptions = [ "defaults" ];
              };
            };

            lv_audio = {
              size = "1000G";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/data/audio";
                mountOptions = [ "defaults" ];
              };
            };

            lv_blender = {
              size = "600G";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/data/blender";
                mountOptions = [ "defaults" ];
              };
            };

            lv_video = {
              # ~500G
              size = "100%FREE";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/data/video";
                mountOptions = [ "defaults" ];
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
                type       = "filesystem";
                format     = "ext4";
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