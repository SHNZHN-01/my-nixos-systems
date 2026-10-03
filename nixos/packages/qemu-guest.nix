_: {
  flake.nixosModules.qemu-guest = _: {
    boot = {
      extraModulePackages = [ ];
      initrd = {
        availableKernelModules = [
          # QEMU/KVM + VirtualBox-virtio (virtio devices)
          "virtio_pci"
          "virtio_blk"
          "virtio_scsi"
          "virtio_net"
          "virtio_balloon"
          "9p"
          "9pnet_virtio"
          # generic SCSI / NVMe
          "xhci_pci"
          "nvme"
          "sym53c8xx"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ ];
      kernelParams = [ "console=ttyS0,115200" ];
    };

    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "modesetting" ];

    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };
  };
}
