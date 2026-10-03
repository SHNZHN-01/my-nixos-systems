_: {
  flake.nixosModules.preferences = { lib, ... }: {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "xor";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
}
