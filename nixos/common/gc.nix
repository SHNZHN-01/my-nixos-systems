_: {
  flake.nixosModules.gc = _: {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };
}
