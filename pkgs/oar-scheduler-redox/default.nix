{ lib, pkgs, fetchFromGitLab, python3Packages, ... }:

python3Packages.buildPythonPackage rec {
  pname = "oar-scheduler-redox";
  version = "0.0.1";
  pyproject = true;
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "4d40ac3ce92bc51cf3c68a719485e723b9a02ded";
    sha256 = "sha256-pp43BSfrNxBv2yy7TS+Dike0eo4a2hwFE/YGQoM9pC4=";
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
  configurePhase = ''cd oar3-scheduler-lib'';

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
          
