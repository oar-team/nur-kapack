{
  lib ? import <nixpkgs/lib> {},
  callPackage,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  cython,
  setuptools,
  scip ? callPackage ./scip.nix {},
  ...
}: let
  pyscipopt-src =
    (import ../_sources/generated.nix {
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .pyscipopt;
in
  buildPythonPackage {
    inherit (pyscipopt-src) pname src;

    version = let
      matches = builtins.match "v(.+)" pyscipopt-src.version;
    in
      builtins.head matches;

    pyproject = true;

    nativeBuildInputs = [
      cython
      setuptools
    ];

    enableParallelBuilding = true;

    patches = [../patches/pyscipopt_dirs.patch];

    SCIPINCLUDEDIR = "${scip.dev}/include";
    SCIPLIBDIR = "${scip.out}/lib";

    meta = {
      description = "Python interface for the SCIP Optimization Suite";
      homepage = "https://scipopt.github.io/PySCIPOpt/docs/html/index.html";
      license = lib.licenses.mit;
    };
  }
