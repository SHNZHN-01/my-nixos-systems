{ ... }: {
  flake.nixosModules.boot =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        loader = {
          systemd-boot.enable = false;
          limine = {
            enable = true;
            secureBoot.enable = true;
            enrollConfig = true;
            panicOnChecksumMismatch = true;
            maxGenerations = 5;
            extraConfig = ''
              TIMEOUT: 10800
            '';
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };

        kernelPackages = pkgs.linuxPackages_latest;
        tmp = {
          useTmpfs = true;
          tmpfsSize = "16G";
        };
      };
    };
}
