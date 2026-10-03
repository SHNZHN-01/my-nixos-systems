_: {
  flake.nixosModules.cpu-intel = _: {
    hardware.cpu.intel.updateMicrocode = true;
    boot.kernelModules = [ "kvm-intel" ];
  };
}
