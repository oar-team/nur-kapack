{ lib, pkgs, fetchFromGitLab, python3Packages, ... }:

python3Packages.buildPythonPackage rec {
  pname = "oar-scheduler-redox";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "f4d54c9ae87d2cc033b56375349b4ff7b6ce1cfc";
    sha256 = "sha256-kO037UKf1JdWDswoCnrHF9/brnRFF/c6P1vvEnXpINg=";
  };

  nativeBuildInputs = with pkgs; [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  #propagatedBuildInputs = with pkgs.python3Packages; [
  #  kapack-pkgs.oar
  #];

  #propagatedBuildInputs = with pkgs-unstable.python3Packages; [
  #  kapack-pkgs.oar
  #];

  # find a better way to indicate where to operate
  configurePhase = ''cd oar-scheduler-redox'';

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  meta = {
    homepage = "https://gitlab.inria.fr/OAR/stages/cgrenner-oar3-rust-scheduler";
    description = "Rust scheduler implementation for OAR3";
    license = lib.licenses.gpl3;
    longDescription = "";
  };

}
          
