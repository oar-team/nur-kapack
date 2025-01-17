{ lib
, stdenv
, fetchFromGitLab
, gfortran  
}:

stdenv.mkDerivation rec {
  pname = "timestamps";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "utils";
    repo = pname;
    rev = "6a455809a44321f058a8249d9656cb7f537f35f3";
    sha256 = "sha256-y6F5dSq4iNi+vAmiJObVn/IEzgWy1n5MCipnrG4cR80=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  
  buildPhase = "make all";

  installPhase = ''
    mkdir -p $out
    make all install INSTALL_DIR=$out
  '';

  meta = with lib; {
    description = "This library provides a simple utility to create timestamps in iterative, dynamic applications.";
    homepage = "https://gitlab.inria.fr/dynres/utils/timestamps";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
