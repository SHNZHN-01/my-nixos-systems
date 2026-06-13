{ ... }: {
  flake.nixosModules.boot = { lib, config, pkgs, ... }: {
    boot.loader = {
        systemd-boot.enable = false;
        limine = {
            enable = true;
            secureBoot.enable = true;
            enrollConfig = true;
            panicOnChecksumMismatch = true;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    # here we can also add the kernelmodules, by default they
    # they sould be empty and we can set them per host/vm configuration  

    boot.tmp.useTmpfs = lib.mkDefault true;
  };
}