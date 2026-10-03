_: {
  flake.nixosModules.console = { pkgs, ... }: {
    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
      earlySetup = true;
    };

    fonts.packages = with pkgs; [
      terminus_font
    ];
  };
}
