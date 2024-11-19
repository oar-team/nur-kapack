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
    rev = "61b45404f74290b27d77ca8a3d965eb2ed275e68";
    sha256 = "sha256-YboVZI0U2bOeyxD3Zzam/WeBoktRCZXbya17KzqkCCE=";
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
