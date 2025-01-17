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
    rev = "710b338457ef002f33d1b4055454c83492c26627";
    sha256 = "sha256-PWpgnEToFVD3BUVZz6/YL7+/A3d67JsjCLh9cEdWjtc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    openmpi-dynres
    xbraid
  ];

  configureFlags = [
    #"--with-mpi=${lib.getDev openmpi-dynres}"
    "--enable-debug"
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
