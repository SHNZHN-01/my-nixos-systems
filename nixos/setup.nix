{ inputs, lib, ... }: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  options.flake.lib = lib.mkOption {
    type    = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  config = {
    #flake.nixosModules = builtins.mapAttrs(_: v: v.install) self.wrappers;

    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  };
}