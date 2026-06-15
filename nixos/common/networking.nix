{ ... }: {
  flake.nixosModules.networking = { lib, config, ... }: {
    networking = {
      hostName = lib.mkDefault "computer";
      networkmanager.enable = lib.mkDefault false;
      dhcpcd.enable = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
      useDHCP = lib.mkDefault true;
      enableIPv6 = lib.mkDefault false;

      nameservers = [ "127.0.0.1" ];
      dhcpcd.extraConfig = "nohook resolv.conf";
    };

    services.resolved.enable = false;
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = [ "127.0.0.1:53" ];
        server_names = [ "cloudflare" ];
        ipv4_servers = true;
        ipv6_servers = false;
        block_ipv6 = true;
        dnscrypt_servers = false;
        doh_servers = true;
        http3 = true;
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = true;
        tls_disable_session_tickets = true;
        dnscrypt_ephemeral_keys = true;
        cert_ignore_timestamp = false;
        bootstrap_resolvers = [
          "1.1.1.1:53"
          "8.8.8.8:53"
          "9.9.9.9:53"
        ];
        ignore_system_dns = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        cache = true;
        cache_size = 4096;
        cache_min_ttl = 2400;
        cache_max_ttl = 86400;
        cache_neg_min_ttl = 60;
        cache_neg_max_ttl = 600;
      };
    };
  };
}
