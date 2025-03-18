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
    rev = "3a8600d3f33769a5899972dcda819c9ceb38f305";
    sha256 = "sha256-nFCFsuTzlXlHEM3n4UcttdjooZykx8uziNqgPgsdPCA=";
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
