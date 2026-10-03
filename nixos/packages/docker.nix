_: {
  flake.nixosModules.docker =
    { config, pkgs, ... }:
    {
      users.users.${config.username} = {
        extraGroups = [
          "docker"
        ];
        packages = with pkgs; [
          docker
        ];
      };

      virtualisation.docker.enable = true;
    };
}
