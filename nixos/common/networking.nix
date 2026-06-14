{ ... }: {
    flake.nixosModules.networking = { lib, config, ... }: {
        networking = {
            hostName = lib.mkDefault "computer";
            networkmanager.enable = lib.mkDefault false;
            dhcpcd.enable = lib.mkDefault true;
            firewall.enable = lib.mkDefault true;
            useDHCP = lib.mkDefault true;

            # TODO: change this
            nameservers = [ "1.1.1.1" ];
        };

        services.resolved.enable = false;
    };
}
