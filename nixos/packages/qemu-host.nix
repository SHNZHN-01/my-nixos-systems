_: {
  flake.nixosModules.qemu-host =
    { config, pkgs, ... }:
    let
      inherit (config) username;
    in
    {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true; # software TPM 2.0 for Win11
        };
      };
      programs.virt-manager.enable = true;

      users.users.${username} = {
        extraGroups = [
          "libvirtd"
          "kvm"
        ];
        packages = with pkgs; [
          # qemu_full
          virtualbox
          virtio-win
        ];
      };
    };
}
