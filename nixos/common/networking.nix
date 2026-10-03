_: {
  flake.nixosModules.networking = { config, lib, ... }: {
    networking = {
      hostName = config.hostname;
      networkmanager.enable = lib.mkDefault false;
      dhcpcd.enable = lib.mkDefault true;
      nftables.enable = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
      enableIPv6 = lib.mkDefault false;

      dhcpcd.extraConfig = "nohook resolv.conf";
    };
  };
}
