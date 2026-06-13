{ self, inputs, ... }: {
    flake.nixosConfigurations.testing = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            self.nixosModules.testing
        ];
    };

    flake.nixosModules.testing = { pkgs, lib, config, ... }: {
        imports = [ 
            self.nixosModules.common
            self.nixosModules.desktop
            self.nixosModules.virtualization

            inputs.disko.nixosModules.disko
            self.diskoConfigurations.testing
        ];

        networking.hostName = "testing";


        system.stateVersion = "26.05";
    };
}
