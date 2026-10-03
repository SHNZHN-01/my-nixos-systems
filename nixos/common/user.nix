_: {
  flake.nixosModules.user =
    { config, ... }:
    let
      inherit (config) username;
    in
    {
      users = {
        users.${username} = {
          isNormalUser = true;
          group = username;
          extraGroups = [
            "wheel"
          ];
          hashedPasswordFile = "/persist/passwords/${username}";
        };
        users.root.hashedPassword = "!";
        groups.${username} = { };
        mutableUsers = false;
      };
    };
}
