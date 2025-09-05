{ lib, pkgs, fetchFromGitLab, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "oar-scheduler-meta-redox";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "85ccb18eb1c656180e07bb07c557d7f60882afec";
    sha256 = "sha256-QRye6uGWNS1/S2rylEZ6gu9Z3DoICWnpqksPEb30XsY=";
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
          
