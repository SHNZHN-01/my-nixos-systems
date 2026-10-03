_: {
  flake.nixosModules.theming = { pkgs, ... }: {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    environment = {
      systemPackages = [
        (pkgs.catppuccin-kvantum.override {
          accent = "blue";
          variant = "mocha";
        })
      ];
      sessionVariables.GTK_THEME = "Adwaita:dark";
      etc."xdg/Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Mocha-Blue
      '';
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      }
    ];
  };
}
