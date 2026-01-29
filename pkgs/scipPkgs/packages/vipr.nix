{
  pkgs ? import <nixpkgs> {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  ...
}: let
  vipr-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .vipr;
in
  pkgs.stdenv.mkDerivation {
    inherit (vipr-src) pname version;

    src = "${vipr-src.src}/code";

    nativeBuildInputs = [pkgs.cmake];

    buildInputs = with pkgs; [
      boost
      gmp
      soplex
      tbb_2021_8
      zlib
    ];

    patches = [
      ../patches/vipr_install.patch
    ];

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "Verifying Integer Programming Results";
      homepage = "https://github.com/scipopt/vipr";
      license = [];
    };
  }
