{ lib, pkgs, fetchFromGitLab, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "oar-scheduler-meta-redox";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    repo = "stages/cgrenner-oar3-rust-scheduler";
    rev = "00c7478dc2a520a479717d910b56307f0206efb9";
    sha256 = "sha256-k+Yw4fOsWYw033TLhVk2NSiprfYpUKY8cWSoFMuO3OQ=";
  };

  # find a better way to indicate where to operate
  #configurePhase = ''cd oar-scheduler-meta'';
  cargoBuildFlags = [ "--package" "oar-scheduler-meta" ];
  cargoInstallFlags = [ "--package" "oar-scheduler-meta" ];
 
  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  doCheck = false;
  
  meta = {
    homepage = "https://gitlab.inria.fr/OAR/stages/cgrenner-oar3-rust-scheduler";
    description = "Rust scheduler implementation for OAR3";
    license = lib.licenses.gpl3;
    longDescription = "";
  };

}
          
