{ ... }: {
  flake.wrappers.polybar = { config, wlib, lib, pkgs, ... }:
  let
    iniFmt = pkgs.formats.ini { };
  in
  {
    imports = [ wlib.modules.default ];
    options = {
      settings = lib.mkOption {
        inherit (iniFmt) type;
        default = { };
        description = ''
          Polybar configuration
        '';
      };
    };

    config = {
      package = pkgs.polybar;

      flags = {
        "-c" = config.constructFiles.generatedConfig.path;
      };

      constructFiles.generatedConfig = {
        content = lib.generators.toINI { } config.settings;
        relPath = "${config.binName}-config.ini";
      };
    };
  };
}