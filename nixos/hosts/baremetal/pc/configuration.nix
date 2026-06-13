{ self, inputs, ... }: {
    flake.nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            self.nixosModules.desktopConfiguration
        ];
    };

    flake.nixosModules.pc = { pkgs, lib, config, ... }: {
        imports = [ 
            self.nixosModules.common
            self.nixosModules.desktop

            inputs.disko.nixosModules.disko
            self.diskoConfigurations.pc
        ];

        networking.hostName = "computer";

        system.stateVersion = "26.05";
    };
}
