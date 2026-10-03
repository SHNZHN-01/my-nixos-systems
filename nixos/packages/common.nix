{ self, ... }: {
  flake.nixosModules.common =
    { config, pkgs, ... }:
    let
      wrapped = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = with pkgs; [
        sbctl
      ];

      users.users.${config.username}.packages =
        with pkgs;
        [
          tree
          vim
          file
          fd
          ranger
          pciutils
          usbutils
        ]
        ++ (with wrapped; [
          fzf
        ]);
    };
}
