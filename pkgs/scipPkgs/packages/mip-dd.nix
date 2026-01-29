{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}: let
  mip-dd-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .mip-dd;
in
  pkgs.stdenv.mkDerivation {
    inherit (mip-dd-src) pname src;

    version = let
      matches = builtins.match "v([0-9]+).([0-9]+).([0-9]+)" mip-dd-src.version;
    in
      builtins.concatStringsSep "." matches;

    outputs = [
      "out"
      "dev"
      "bin"
    ];

    nativeBuildInputs = with pkgs; [cmake];

    buildInputs = with pkgs; [
      boost
      tbb_2021_8
      scip
    ];

    enableParallelBuilding = true;
    doCheck = true;

    cmakeFlags = ["-D TBB=ON"];

    meta = {
      description = "Delta-Debugging of MIP-Solvers";
      homepage = "https://github.com/scipopt/MIP-DD";
      license = lib.licenses.asl20;
    };
  }
