# This file generates the configurations for each of our hosts installer ISOs.
#
# It will read our nixosConfigurations and derive the names from there. Ignoring
# the ones that start with "iso-"
#
# The reason we need to do this, is so that we can generate an ISO in which the
# installer script written with pkgs.writeShellScript ends up with #pc and another
# one with #laptop as their targets.
#
# Example build command: `nix build .#nixosConfigurations.iso-testing.config.system.build.isoImage`
{ self, inputs, config, lib, ... }:
let
  hostsDir = ../hosts;
  groups = lib.filterAttrs (_: t: t == "directory") (builtins.readDir hostsDir);
  realHosts = lib.concatLists (lib.mapAttrsToList
    (group: _:
      builtins.attrNames
        (lib.filterAttrs (n: t: t == "directory" && !(lib.hasPrefix "_" n))
          (builtins.readDir (hostsDir + "/${group}"))))
    groups);

  mkIsoConfiguration = hostname:
    { pkgs, config, modulesPath, ... }:
    let
      username = self.nixosConfigurations.${hostname}.config.username;
      installer = pkgs.writeShellScript "auto-install" ''
        #set -euo pipefail
        clear
        echo "===> Partitioning with disko"
        disko --mode destroy,format,mount --flake ${self}#${hostname}
        echo "===> Generating Secure Boot keys"
        sbctl create-keys
        mkdir -p /mnt/var/lib
        cp -a /var/lib/sbctl /mnt/var/lib/
        echo "===> Setting up user credentials"
        mkdir -p /mnt/persist/passwords
        while true; do
          read -rsp "Password for ${username}: " pw1; echo
          read -rsp "Confirm password: "      pw2; echo
          if [ "$pw1" = "$pw2" ] && [ -n "$pw1" ]; then
            break
          fi
          echo "Passwords did not match (or were empty) — try again."
        done
        ( umask 077; printf '%s' "$pw1" | mkpasswd -m sha-512 -s > "/mnt/persist/passwords/${username}" )
        unset pw1 pw2
        chmod 600 "/mnt/persist/passwords/${username}"
        chown root:root "/mnt/persist/passwords/${username}"
        echo "===> Installing NixOS"
        nixos-install --flake ${self}#${hostname} --no-root-passwd
        read -sp "===> Done. Press [ Enter ] to reboot. Remember to enter Setup Mode and run `sbctl enroll-keys` to enable Safe Boot..."
        clear
        reboot
      '';

      # profile = pkgs.writeText "profile" ''
      #   if [ ! -e /tmp/.auto-install-started ]; then
      #     touch /tmp/.auto-install-started
      #     exec ${installer}
      #   fi
      # '';
    in {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        self.nixosModules.nix
      ];

      # systemd.tmpfiles.rules = [
      #   "L+ /root/.profile - - - - ${profile}"
      # ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      services.getty.autologinUser = lib.mkForce "root";
      environment.loginShellInit = ''
        if [ ! -e /tmp/.auto-install-started ] && [ "$(tty)" = "/dev/tty1" ]; then
          touch /tmp/.auto-install-started
          ${installer}
        fi
      '';

      environment.systemPackages = with pkgs; [
        sbctl
        tree
        vim
        disko
        mkpasswd
      ];
    };

  mkInstallerIso = hostname: inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ (mkIsoConfiguration hostname) ];
  };
in {
  flake.nixosConfigurations = lib.listToAttrs (map (h: {
    name = "iso-${h}";
    value = mkInstallerIso h;
  }) realHosts);
}