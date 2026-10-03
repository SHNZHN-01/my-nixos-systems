_: {
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs = {
        gamemode = {
          enable = true;
          enableRenice = true;
        };
        gamescope = {
          capSysNice = true;
          enable = true;
        };
        steam = {
          enable = true;
        };
      };

      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };

      environment.systemPackages = with pkgs; [
        # Battle.net / WoW
        lutris # install Battle.net from its community install scripts
        wineWow64Packages.stable
        winetricks
        libnotify # Battle.net launcher notifications
        cabextract
        p7zip

        # Utilities
        vulkan-tools # vulkaninfo, Vulkan diagnostics
        jstest-gtk # test/calibrate controllers
      ];
    };
}
