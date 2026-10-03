_: {
  flake.nixosModules.ai =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = with pkgs; [
        opencode
        pi-coding-agent
      ];
    };
}
