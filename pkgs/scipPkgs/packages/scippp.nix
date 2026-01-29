{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}: let
  scippp-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .scippp;
in
  pkgs.stdenv.mkDerivation {
    inherit (scippp-src) pname version src;

    nativeBuildInputs = with pkgs; [cmake];

    buildInputs = with pkgs; [
      boost
      scip
    ];

    outputs = [
      "dev"
      "out"
    ];

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "A C++ wrapper for SCIP";
      homepage = "https://scipopt.github.io/SCIPpp/";
      license = lib.licenses.asl20;
    };
  }
