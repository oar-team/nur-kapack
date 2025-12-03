{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/25.11"; };
  outputs = { self, nixpkgs }:
    let
      consideredSystems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
        "armv6l-linux"
        "armv7l-linux"
      ];
      nixpkgsConfig = {
        allowBroken = true;
        permittedInsecurePackages = [
            "python-2.7.18.8" # for slurm-bsc-simulator because python2 reached EoL
        ];
      };
      # Doing the job of `flake-utils`
      forAllSystems = function:
        builtins.listToAttrs (builtins.map (system: {
          name = system;
          value = function (import nixpkgs { inherit system; config = nixpkgsConfig; });
        }) consideredSystems);
    in {
      packages =
        forAllSystems (pkgs: import ./all-packages.nix { inherit pkgs; });
      nixosModules =
        builtins.mapAttrs (name: path: import path) (import ./modules);
      overlays.default = import ./overlay.nix;
    };
}
