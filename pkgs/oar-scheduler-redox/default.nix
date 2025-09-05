{ lib, pkgs, fetchFromGitLab, python3Packages, ... }:

python3Packages.buildPythonPackage rec {
  pname = "oar-scheduler-redox";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "85ccb18eb1c656180e07bb07c557d7f60882afec";
    sha256 = "sha256-QRye6uGWNS1/S2rylEZ6gu9Z3DoICWnpqksPEb30XsY=";
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
          
