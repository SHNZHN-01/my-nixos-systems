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
{
  self,
  inputs,
  lib,
  ...
}:
let
  hostsDir = ../hosts;
  groups = lib.filterAttrs (_: t: t == "directory") (builtins.readDir hostsDir);
  realHosts = lib.concatLists (
    lib.mapAttrsToList (
      group: _:
      builtins.attrNames (
        lib.filterAttrs (n: t: t == "directory" && !(lib.hasPrefix "_" n)) (
          builtins.readDir (hostsDir + "/${group}")
        )
      )
    ) groups
  );
  installableHosts = builtins.filter (h: self.diskoConfigurations ? ${h}) realHosts;

  mkIsoConfiguration =
    hostname:
    {
      pkgs,
      modulesPath,
      ...
    }:
    let
      username = self.nixosConfigurations.${hostname}.config.username;

      installer = pkgs.writeShellScript "auto-install" ''
        set -euo pipefail
        clear

        echo "===> Setting DNS servers"
        resolvectl dns "$(ip -o -4 route show default | awk '{print $5}' | head -1)" 1.1.1.1 8.8.8.8 2>/dev/null || \
          printf 'nameserver 1.1.1.1\nnameserver 8.8.8.8\n' > /etc/resolv.conf

        echo "===> Waiting for network..."
        until ping -c1 cache.nixos.org &>/dev/null; do
          sleep 2
        done

        ${lib.optionalString (hostname == "homelab") ''
          echo "===> Generating LUKS enrollment and storage keys"
          ( umask 077
            dd if=/dev/urandom of=/tmp/enroll.key  bs=64 count=1 status=none
            dd if=/dev/urandom of=/tmp/storage.key bs=64 count=1 status=none )
        ''}

        echo "===> Partitioning with disko"
        disko --mode destroy,format,mount --flake ${self}#${hostname}

        ${lib.optionalString (hostname == "homelab") ''
          install -d -m 700 /mnt/var/lib/luks
          install -m 400 /tmp/enroll.key /tmp/storage.key /mnt/var/lib/luks/
          rm -f /tmp/enroll.key /tmp/storage.key
        ''}

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
        read -sp "===> Done. Press [ Enter ] to reboot. Remember to enter Setup Mode and run \`sbctl enroll-keys -m\` to enable Secure Boot..." || true
        clear
        reboot
      '';
    in
    {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        self.nixosModules.nix
      ];

      image.fileName = "iso-${hostname}.iso";

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

  mkInstallerIso =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ (mkIsoConfiguration hostname) ];
    };
in
{
  flake.nixosConfigurations = lib.listToAttrs (
    map (h: {
      name = "iso-${h}";
      value = mkInstallerIso h;
    }) installableHosts
  );
}
