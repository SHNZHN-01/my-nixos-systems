_: {
  flake.nixosModules.boot =
    {
      pkgs,
      lib,
      ...
    }:
    {
      boot = {
        initrd.systemd.emergencyAccess = false;
        loader = {
          systemd-boot.enable = false;
          limine = {
            enable = true;
            enableEditor = false;
            secureBoot.enable = true;
            enrollConfig = true;
            panicOnChecksumMismatch = true;
            maxGenerations = 5;
            extraConfig = ''
              TIMEOUT: 3
              term_font_scale=1x1
            '';
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };

        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        tmp = {
          useTmpfs = true;
          tmpfsSize = "16G";
        };
      };
    };
}
