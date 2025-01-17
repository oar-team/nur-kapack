{ lib
, stdenv
, fetchFromGitLab
, openmpi-dynres
, p4est-dynres
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "p4est_dyn";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "b2bcbe5145a8ea6a4c26d8cd18e194fb0cc0c34b";
    sha256 = "sha256-qpG4WAb8+22OxA3qD4/V+q7hvbLwyhPg0nBhVJBxXxY=";
  };

  nativeBuildInputs = [
    openmpi-dynres
    p4est-dynres
    autoreconfHook
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-mpi=${openmpi-dynres}"
    "--with-p4est=${p4est-dynres}"
  ];

  meta = with lib; {
    description = "Dynamic Resource Extensions for P4est.";
    homepage = "https://gitlab.inria.fr/dynres/applications/p4est_dyn";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
