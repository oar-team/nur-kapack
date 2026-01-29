# like https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/development/libraries/science/math/ipopt/default.nix but using MUMPS
{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  mumps ? pkgs.callPackage ./mumps.nix {},
  ...
}:
assert (!pkgs.blas.isILP64) && (!pkgs.lapack.isILP64); let
  ipopt-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .ipopt;
in
  pkgs.stdenv.mkDerivation {
    pname = "ipopt-mumps";

    version = let
      matches = builtins.match "releases\/([0-9]+)\.([0-9]+)\.([0-9]+)" ipopt-src.version;
    in
      builtins.concatStringsSep "." matches;

    inherit (ipopt-src) src;

    nativeBuildInputs = [pkgs.pkg-config];

    buildInputs = [
      pkgs.blas
      pkgs.lapack
      mumps
    ];

    outputs = ["out" "dev" "doc"];

    enableParallelBuilding = true;

    meta = {
      description = "A software package for large-scale nonlinear optimization (using MUMPS)";
      homepage = "https://projects.coin-or.org/Ipopt";
      license = lib.licenses.epl10;
    };
  }
