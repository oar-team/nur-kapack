{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scipoptsuite-src ? pkgs.callPackage ./scipoptsuite-src.nix {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "ug";
  version = "1.0.0";

  # Not publicly available apart from the SCIP Optimization Suite
  src = assert (
    lib.strings.versionAtLeast scipoptsuite-src.version "9.0.1"
    && lib.strings.versionOlder scipoptsuite-src.version "9.0.2"
  ); "${scipoptsuite-src}/ug"; # check for scipopt suite version that ships correct zimpl version

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs; [
    mpi
    scip # PARASCIP is deprecated, THREADSAFE is on by default
    zlib
  ];

  meta = {
    description = "Framework to parallelize branch-and-bound based solvers (e.g., MIP, MINLP, ExactIP) in a distributed or shared memory computing environment";
    homepage = "https://ug.zib.de/";
    license = lib.licenses.lgpl3;
  };
}
