_: {
  flake.nixosModules.ssh-configs =
    { config, ... }:
    let
      inherit (config) username;
    in
    {
      programs.ssh.extraConfig = ''
        Host homelab
          HostName homelab.shnzhn
          User ${username}
          IdentityFile ~/.ssh/homelab
          IdentitiesOnly yes
      '';
    };
}
