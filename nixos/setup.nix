{self, inputs, lib, ... }: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  #flake.nixosModules = builtins.mapAttrs(_: v: v.install) self.wrappers;

  systems = inputs.nixpkgs.lib.platforms.all;
}