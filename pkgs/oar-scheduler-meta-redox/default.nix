{ lib, pkgs, fetchFromGitLab, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "oar-scheduler-meta-redox";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "d92ba5a9f46c6b8846a38dd0dd50473dda1e7be8";
    sha256 = "sha256-uZ3oEKX0TGusrfBs4omMW03NVn9EYidbCs/HsK/uT58=";
  };

  # find a better way to indicate where to operate
  #configurePhase = ''cd oar-scheduler-meta'';
  cargoBuildFlags = [ "--package" "oar-scheduler-meta" ];
  cargoInstallFlags = [ "--package" "oar-scheduler-meta" ];

  cargoHash = "sha256-Va6VXEqwX/k620k5W4Q+5mAGsf+FJkVdPtGCv5XiYac=";
  #sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";

  # cargoDeps = pkgs.rustPlatform.importCargoLock {
  #   lockFile = ./Cargo.lock;
  # };

  doCheck = false;

  meta = {
    homepage = "https://gitlab.inria.fr/OAR/stages/cgrenner-oar3-rust-scheduler";
    description = "Rust scheduler implementation for OAR3";
    license = lib.licenses.gpl3;
    longDescription = "";
  };

}
          
