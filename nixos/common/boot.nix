{ ... }: {
  flake.nixosModules.boot =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
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

      boot.tmp.useTmpfs = true;
      boot.tmp.tmpfsSize = "16G";
    };
}
