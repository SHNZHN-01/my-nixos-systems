_: {
  flake.nixosModules.cpu-amd = _: {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelModules = [ "kvm-amd" ];
  };
}
