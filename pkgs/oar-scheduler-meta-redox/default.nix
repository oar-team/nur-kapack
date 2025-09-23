{ lib, pkgs, fetchFromGitLab, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "oar-scheduler-meta-redox";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "99f667c822eaac4adc5f73142ee5fdffd4290f5d";
    sha256 = "sha256-cvuBpvPulYBlMyw1p0OLJwZI3aDeSXDGmP0EZ+kddgQ=";
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
          
