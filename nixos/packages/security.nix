_: {
  flake.nixosModules.security =
    { config, pkgs, ... }:
    {
      users.users.${config.username}.packages = with pkgs; [
        gdb
        gef
        pwntools
        aflplusplus
        binaryninja-free
        binsider
        patchelf
        frida-tools
        burpsuite
        wireshark
        tshark
        termshark
        tcpdump
        dnsutils
        nmap
        sqlmap
        nuclei
        hashcat
        hcxdumptool
        aircrack-ng
        android-tools
        apktool
        jadx
        objection
        trufflehog
        trivy
        gitleaks
        dep-scan
        cve-bin-tool
        codeql
        openssl
        veracrypt
        binwalk
      ];
    };
}
