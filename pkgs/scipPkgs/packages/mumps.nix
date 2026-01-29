{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  ...
}: let
  mumps-harness-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .mumps-harness;

  mumps-src = pkgs.stdenvNoCC.mkDerivation {
    pname = "mumps-source";
    version = "5.7.1";

    inherit (mumps-harness-src) src;

    nativeBuildInputs = [
      pkgs.which
      pkgs.wget
    ];

    phases = [
      "unpackPhase"
      "installPhase"
    ];

    installPhase = ''
      runHook preInstall

      ./get.Mumps

      cp -r MUMPS $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-uh6+HPE+2tvbEIL7Nr7AJS2QjoiHJMGqwLmk2uCDMG8=";
    outputHashAlgo = "sha256";
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "mumps";
    inherit (mumps-src) version;

    outputs = ["out" "dev"];

    unpackPhase = ''
      runHook preUnpack

      mkdir MUMPS
      cp -r ${mumps-src}/* MUMPS

      cp -r ${mumps-harness-src.src}/* .

      chmod -R +w MUMPS

      runHook postUnpack
    '';

    nativeBuildInputs = [pkgs.gfortran];

    buildInputs = [pkgs.lapack];

    configureFlags = ["--with-lapack-lflags=-llapack"];

    enableParallelBuilding = true;

    meta = {
      description = "A parallel sparse direct solver";
      homepage = "https://mumps-solver.org/index.php";
      license = with lib.licenses; [cecill-c bsd3 epl10];
    };
  }
