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
    rev = "d85630217bdaed84543e83bd18ba43d4dea3b326";
    sha256 = "sha256-0721eTBeJ1pwdlkOpKTLz/aWc2AI5G9i8WoAWZBYNLg=";
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
