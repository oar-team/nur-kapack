{ lib, pkgs, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "oar-scheduler-meta-redox";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar-scheduler-redox";
    rev = "015bdbde61a41e6de2380d6ab8385e13e991ce81";
    sha256 = "sha256-ElM08wGgmyajTikaHJ2DCuwx7KWWJksVCiB+vP+1YtY=";
  };

  buildType = "debug";
  dontStrip = true;

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
          
