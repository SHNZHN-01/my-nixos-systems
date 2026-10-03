_: {
  flake.nixosModules.cli =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = with pkgs; [
        btop
        git
        ripgrep
        wiremix
        bat
        bat-extras.batman
        dtach
        eza
        gh
        playerctl
        lsof
        efibootmgr
        jq
        unzip
      ];
    };
}
