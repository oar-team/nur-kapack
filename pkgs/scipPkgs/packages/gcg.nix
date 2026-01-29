{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  debugFiles ? [], # add `#define SCIP_DEBUG` to these files (e.g. ["src/gcg/cons_decomp.cpp"])
  ...
}: let
  gcg-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .gcg;
in
  pkgs.stdenv.mkDerivation {
    inherit (gcg-src) pname src;

    version = let
      matches = builtins.match "v([0-9]+)([0-9])([0-9])" gcg-src.version;
    in
      builtins.concatStringsSep "." matches;

    nativeBuildInputs = with pkgs; [
      cmake
      git # to obtain git commit hash
    ];

    buildInputs =
      (with pkgs; [
        cliquer
        gmp
        gsl
        (bliss.overrideAttrs (oldAttrs: {
          installPhase =
            oldAttrs.installPhase
            + ''
              mv $out/lib/libbliss.a $out/lib/liblibbliss.a
            '';
        }))
      ])
      ++ [scip];

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/gcg_dirs.patch
    ];

    postPatch = ''
      # Add #define SCIP_DEBUG to debug files
      for file in ${builtins.concatStringsSep " " debugFiles}; do
        sed -i '1s/^/#define SCIP_DEBUG\n/' $file
      done
    '';

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "Branch-and-Price & Column Generation for Everyone";
      homepage = "https://gcg.or.rwth-aachen.de/";
      license = lib.licenses.lgpl3;
    };
  }
