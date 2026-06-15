{ ... }: {
  flake.nixosModules.localetime = { ... }: {
      time.timeZone = "America/Argentina/Buenos_Aires";
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
          font = "ter-v14n";
          keyMap = "us";
          # useXkbConfig = true; use xkb.options in tty.
      };
  };
}
