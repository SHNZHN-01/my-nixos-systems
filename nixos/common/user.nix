{ ... }: {
  flake.nixosModules.user =
    { config, ... }:
    let
      username = config.username;
    in
    {
      users.users.${username} = {
        isNormalUser = true;
        group = username;
        extraGroups = [
          "wheel"
        ];
        hashedPasswordFile = "/persist/passwords/${username}";
      };

      users.users.root.hashedPassword = "!";
      users.groups.${username} = { };
      users.mutableUsers = false;
    };
}
