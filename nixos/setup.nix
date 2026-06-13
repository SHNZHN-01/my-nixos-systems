{self, inputs, lib, ... }: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  #flake.nixosModules = builtins.mapAttrs(_: v: v.install) self.wrappers;

  systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
}