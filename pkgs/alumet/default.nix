{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "alumet";
  version = "0.6.1";

  src = fetchFromGitHub {
     owner = "alumet-dev";
     repo = pname;
     rev = "79df2fb4b3f81b8b513c1d402608bc44c37eae6d";
     hash = "sha256-l7bEgiVCDqKg96c9iBm50olucdeKOofqRPNGxtSwCLo=";
  };

  
  buildInputs = [
    openssl
    pkg-config
  ];
  

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    homepage = https://github.com/oar-team;
    description = "Monitoring processes inside cgroup";
    license = licenses.lgpl2;
    #broken = true;
  };
}
