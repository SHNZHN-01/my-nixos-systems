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

  # ── LUKS helpers ──────────────────────────────────────────────────────────
  #
  # Given a host's disko disk attrset, returns a list of partition device paths
  # that have LUKS content. Uses the by-path device string from disko and
  # appends the -partN suffix based on partition position.
  #
  # Disko's `partitions` is an attrset but insertion order matters for numbering.
  # We sort by name to get a stable index, matching how disko/parted lays them out.
  # NOTE: if your partitions have a specific order that doesn't match alphabetical,
  # override this with an explicit list in the host config instead.
  getLuksPartitions = disks:
    lib.concatLists (lib.mapAttrsToList (_diskName: disk:
      let
        partitions   = disk.content.partitions or {};
        # attrNames returns keys in alphabetical order — same order disko uses
        partNames    = builtins.attrNames partitions;
        # zip each partition name with its 1-based index
        indexed      = lib.imap1 (i: name: { inherit i name; }) partNames;
        luksEntries  = builtins.filter
          (entry: (partitions.${entry.name}.content.type or "") == "luks")
          indexed;
        baseDevice   = disk.device;
      in
        map (entry: "${baseDevice}-part${toString entry.i}") luksEntries
    ) disks);

  mkIsoConfiguration = hostname:
    { pkgs, config, modulesPath, ... }:
    let
      username   = self.nixosConfigurations.${hostname}.config.username;
      disks      = self.nixosConfigurations.${hostname}.config.disko.devices.disk or {};
      luksDevices = getLuksPartitions disks;

      # Only generate/enroll a keyfile if there are multiple LUKS containers.
      # A single encrypted disk needs no keyfile — there's only one password prompt anyway.
      needsKeyfile = (builtins.length luksDevices) > 1;

      # The first LUKS device is the primary one (unlocked interactively).
      # The rest are enrolled with the keyfile.
      secondaryDevices = if needsKeyfile then builtins.tail luksDevices else [];

      installer = pkgs.writeShellScript "auto-install" ''
        #set -euo pipefail
        clear

        echo "===> Waiting for network..."
        systemctl is-active --wait network-online.target &>/dev/null
        until ping -c1 cache.nixos.org &>/dev/null; do
          sleep 2
        done

        echo "===> Partitioning with disko"
        disko --mode destroy,format,mount --flake ${self}#${hostname}

        ${lib.optionalString needsKeyfile ''
        echo "===> Generating LUKS keyfile for secondary volumes"
        mkdir -p /mnt/secrets
        dd if=/dev/urandom of=/mnt/secrets/crypto_keyfile.bin bs=512 count=4
        chmod 400 /mnt/secrets/crypto_keyfile.bin
        chown root:root /mnt/secrets/crypto_keyfile.bin

        echo "===> Enrolling keyfile — you will be prompted for your LUKS passphrase once per device"
        ${lib.concatMapStringsSep "\n" (dev: ''
          cryptsetup luksAddKey ${dev} /mnt/secrets/crypto_keyfile.bin
        '') secondaryDevices}
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
        read -sp "===> Done. Press [ Enter ] to reboot. Remember to enter Setup Mode and run \`sbctl enroll-keys\` to enable Secure Boot..."
        clear
        reboot
      '';
    in {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        self.nixosModules.nix
      ];

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
