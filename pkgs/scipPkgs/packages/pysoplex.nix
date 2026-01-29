{
  callPackage,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  cython,
  setuptools,
  soplex ? callPackage ./soplex.nix {},
  ...
}: let
  pysoplex-src =
    (import ../_sources/generated.nix {
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .pysoplex;
in
  buildPythonPackage {
    inherit (pysoplex-src) pname version src;

    nativeBuildInputs = [
      cython
      setuptools
    ];

    enableParallelBuilding = true;

    patches = [../patches/pysoplex_dirs.patch];

    SOPLEX_INCLUDE_DIR = "${soplex.dev}/include";
    SOPLEX_LIB_DIR = "${soplex.out}/lib";

    meta = {
      description = "Python interface for the SoPlex solver";
      homepage = "https://github.com/scipopt/pysoplex";
      license = [];
    };
  }
