{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  ...
}: let
  papilo-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .papilo;
in
  pkgs.stdenv.mkDerivation {
    inherit (papilo-src) pname src;

    version = let
      matches = builtins.match "v(.+)" papilo-src.version;
    in
      builtins.head matches;

    nativeBuildInputs = with pkgs; [cmake];

    buildInputs = with pkgs; [
      boost
      gmp
      soplex
      zlib
    ];

    propagatedBuildInputs = with pkgs; [
      tbb_2021_8
    ];

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/papilo_dirs.patch
    ];

    doCheck = true;

    meta = {
      description = "Parallel Presolve for Integer and Linear Optimization";
      homepage = "https://github.com/scipopt/papilo";
      license = lib.licenses.lgpl3;
    };
  }
