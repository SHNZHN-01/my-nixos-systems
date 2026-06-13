{ ... }: {
  flake.nixosModules.virtualized = { config, lib, ... }:
    let
      username = config.username;
      host = config.platform;
    in {
      virtualisation.virtualbox.guest.enable = true;
      virtualisation.virtualbox.guest.dragAndDrop = true;
      users.users.${username}.extraGroups = [ "vboxsf" ];

      # config = lib.mkMerge [
      #   (lib.mkIf (host == "virtualbox") {
      #     virtualisation.virtualbox.guest.enable = true;
      #     virtualisation.virtualbox.guest.dragAndDrop = true;
      #     users.users.${username}.extraGroups = [ "vboxsf" ];
      #   })
      #   (lib.mkIf (host == "qemu") {
      #     services.qemuGuest.enable = true;
      #     services.spice-vdagentd.enable = true;
      #   })
      # ];
    };
}