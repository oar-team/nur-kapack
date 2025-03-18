{ lib
, stdenv
, autoreconfHook
, fetchFromGitLab
, openmpi-dynres
, xbraid
, dmr
}:

stdenv.mkDerivation rec {
  pname = "dyn_xbraid";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "f14616223f0865ce43eb17548bc69932f476886c";
    sha256 = "sha256-OBaJaCsXFlQoVPcyT2l8qcHaJBz8dSy1Fs2eUNAxN+k=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    openmpi-dynres
    xbraid
  ];

  configureFlags = [
    #"--with-mpi=${lib.getDev openmpi-dynres}"
    #"--enable-debug"
    "--with-mpi=${openmpi-dynres}"
    "--with-xbraid=${xbraid}"
    "--with-dmr=${dmr}"
  ];

  meta = with lib; {
    description = "Dynamic Resource Extensions for Xbraid.";
    homepage = "https://gitlab.inria.fr/dynres/applications/dyn_xbraid";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
