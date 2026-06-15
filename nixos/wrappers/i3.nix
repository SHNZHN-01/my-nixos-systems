# TODO: create a toPolybarConfig function that works. Like "toINI"
{ ... }: {
  flake.wrappers.i3 =
    {
      config,
      lib,
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      options = {
        configContent = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Configuration contents";
        };
      };

      config = {
        package = pkgs.i3;

        constructFiles.generatedConfig = {
          relPath = "${config.binName}-config";
          content = config.configContent;
          # content = toPolybarConfig { } config.settings;
        };

        flags = {
          "-c" = config.constructFiles.generatedConfig.path;
        };
      };

    };
}
