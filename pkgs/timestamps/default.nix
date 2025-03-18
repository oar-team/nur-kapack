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
    rev = "73eee07d833438240a97fe19b875f890e463228c";
    sha256 = "sha256-anayPS5kdeMQwg2TPpNfctsgtMOXMABQcVKeKLsrfqg=";
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
