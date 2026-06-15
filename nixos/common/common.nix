# nix/common/common.nix is for attributes and packages that
# must will be present in every single HOST (vm or baremetal).
#
# This is NOT for the ISOs
{ self, ... }: {
  flake.nixosModules.common =
    { config, pkgs, ... }:
    let
      wrapped = self.packages.${pkgs.system};
    in
    {
      imports = [
        self.nixosModules.boot
        self.nixosModules.user
        self.nixosModules.localetime
        self.nixosModules.nix
        self.nixosModules.preferences
        self.nixosModules.networking
        self.nixosModules.theme
      ];

      console = {
        font = "ter-v14n";
        keyMap = "us";
        # useXkbConfig = true; use xkb.options in tty.
      };

      # systemd.services.sbctl-enroll = {
      #   description = "Enroll Secure Boot keys (once, if firmware is in Setup Mode)";
      #   wantedBy = [ "multi-user.target" ];
      #   after = [ "local-fs.target" ];
      #   unitConfig.ConditionPathExists = "!/var/lib/sbctl/.enrolled";   # run only until done
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = true;
      #   };
      #   path = [ pkgs.sbctl ];
      #   script = ''
      #     # only enroll if firmware is actually in Setup Mode, else we'd error/brick
      #     if sbctl status | grep -qi 'setup mode.*enabled'; then
      #       sbctl enroll-keys --yes-this-might-brick-my-machine
      #       touch /var/lib/sbctl/.enrolled
      #     else
      #       echo "Firmware not in Setup Mode — skipping enrollment."
      #     fi
      #   '';
      # };

      environment.systemPackages = with pkgs; [
        sbctl
      ];

      fonts.packages = with pkgs; [
        terminus_font
      ];

      users.users.${config.username}.packages =
        with pkgs;
        [
          tree
          vim
          file
          fd
          ranger
          pciutils
        ]
        ++ (with wrapped; [
          fzf
        ]);
    };
}
