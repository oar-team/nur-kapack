{
  description = "My Optimization Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    scipopt-nix = {
      url = "github:Lichthagel/scipopt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    scipopt-nix,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    eachSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            scipoptPkgs = scipopt-nix.packages."${system}";
          }
      );
  in {
    packages = eachSystems (
      {
        pkgs,
        scipoptPkgs,
        ...
      }: {
        default = pkgs.stdenv.mkDerivation {
          name = "my-project";

          src = ./.;

          nativeBuildInputs = with pkgs; [cmake];

          buildInputs = with scipoptPkgs; [scip];
        };
      }
    );
  };
}
