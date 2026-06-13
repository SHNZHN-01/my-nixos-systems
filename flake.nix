{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        neovim-shnzhn = {
            url = "github:SHNZHN-01/my-neovim-config";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake { inherit inputs; } {
            imports = [
                inputs.disko.flakeModules.default
                (inputs.import-tree ./nixos)
            ];
        };
}
