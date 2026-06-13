# TODO: the devive path only works for virtual box. Make this work dynamically for QEMU
{
  flake.diskoConfigurations.testing = {
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

            # root partition
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}