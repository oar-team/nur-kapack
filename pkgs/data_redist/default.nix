{ lib
, stdenv
, fetchFromGitLab
, openmpi  
}:

stdenv.mkDerivation rec {
  pname = "data_redist";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "utils";
    repo = pname;
    rev = "d883e2e06d852ec910ab746dc85f9094dd31b514";
    sha256 = "sha256-tJ2pu1yu90eUbO1st0AaLUClxlXooqXNNJgWCtmcliQ=";
  };

  nativeBuildInputs = [
    openmpi
  ];
  
  buildPhase = "make all";

  installPhase = "make install INSTALL_DIR=$out"; 
  
  meta = with lib; {
    description = "This library provides a simple utility to create timestamps in iterative, dynamic applications.";
    homepage = "https://gitlab.inria.fr/dynres/utils/timestamps";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
