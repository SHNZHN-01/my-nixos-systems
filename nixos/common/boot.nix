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
              term_font_scale=1x1
            '';
            resolution = "2560x1440";
            # style.graphicalTerminal.font.scale = "2x2";
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
