{
  description = " My personal NUR repository";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    haskellPackagesNUR = {
      url = "path:./pkgs/haskellPackages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, haskellPackagesNUR }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      inherit (flake-utils.lib) eachSystem filterPackages;

    in eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowBroken = true; # FIXME
        };
      in {
        packages = (filterPackages system (import ./nur.nix { inherit pkgs; })
          // haskellPackagesNUR.packages.${system});
      }) // {
        nixosModules =
          builtins.mapAttrs (name: path: import path) (import ./modules);
        overlay = import ./overlay.nix;
      };
}
