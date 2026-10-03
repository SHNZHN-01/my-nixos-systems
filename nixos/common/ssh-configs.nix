_: {
  flake.nixosModules.ssh-configs =
    { config, ... }:
    let
      inherit (config) username;
    in
    {
      programs.ssh.extraConfig = ''
        Host homelab
          HostName 10.10.40.10
          User ${username}
          IdentityFile ~/.ssh/homelab
          IdentitiesOnly yes
      '';
    };
}
