{
  description = "Flake Haskell Packages NUR";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: 
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
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = (filterPackages system (import ./default.nix { inherit pkgs; }));
      });
}
