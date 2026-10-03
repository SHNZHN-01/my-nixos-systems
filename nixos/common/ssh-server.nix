{ self, ... }: {
  flake.nixosModules.ssh-server =
    { config, ... }:
    {
      services.openssh = {
        enable = true;
        openFirewall = false;

        hostKeys = [
          {
            type = "ed25519";
            path = "/etc/ssh/ssh_host_ed25519_key";
          }
        ];

        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AuthenticationMethods = "publickey";
          AllowUsers = [ config.username ];
          MaxAuthTries = 2;
          LoginGraceTime = 15;
          X11Forwarding = false;
          AllowTcpForwarding = false;
          AllowAgentForwarding = false;
          PermitTunnel = "no";
          PermitUserEnvironment = false;
          AllowStreamLocalForwarding = false;
        };
      };

      users.users.${config.username}.openssh.authorizedKeys.keys = [
        self.sshPublicKeys.xor-computer
      ];
    };
}
