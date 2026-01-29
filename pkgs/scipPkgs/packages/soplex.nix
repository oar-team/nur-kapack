{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  ...
}: let
  soplex-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .soplex;
in
  pkgs.stdenv.mkDerivation {
    inherit (soplex-src) pname src;

    version = let
      matches = builtins.match "release-([0-9]+)([0-9])([0-9])" soplex-src.version;
    in
      builtins.concatStringsSep "." matches;

    nativeBuildInputs = with pkgs; [
      cmake
      git
    ];

    buildInputs = with pkgs; [
      boost
      gmp
      zlib
    ];

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/soplex_dirs.patch
    ];

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "Sequential object-oriented simPlex";
      homepage = "https://soplex.zib.de/";
      license = lib.licenses.asl20;
    };
  }
