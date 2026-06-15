{ ... }: {
  flake.nixosModules.localetime = { ... }: {
    time.timeZone = "America/Argentina/Buenos_Aires";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
