_: {
  flake.nixosModules.apps =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = with pkgs; [
        firefox
        google-chrome
        ungoogled-chromium
        discord
        spotify
        keepassxc
      ];
    };
}
