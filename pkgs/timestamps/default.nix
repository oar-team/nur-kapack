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
    rev = "d023aa52eed095f43703cf241deebae186194139";
    sha256 = "sha256-2t6EJd4/We68G/sDN/i8bNqTpHE7SDagJdVIXKvQg1Q=";
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
