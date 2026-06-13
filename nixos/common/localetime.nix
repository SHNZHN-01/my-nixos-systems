{ ... }: {
  flake.nixosModules.localetime = { ... }: {
      time.timeZone = "America/Argentina/Buenos_Aires";
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
          font = "Lat2-Terminus16";
          keyMap = "us";
          # useXkbConfig = true; use xkb.options in tty.
      };
  };
}