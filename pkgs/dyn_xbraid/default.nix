{ lib
, stdenv
,  autoreconfHook
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
    rev = "58b4cb2c38e5039610651b27ac9af759f4783526";
    sha256 = "sha256-KdMwy1Cpi67LZw6HSIDmn5rDfxyprJwyHQxNCy9A2/0=";
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
