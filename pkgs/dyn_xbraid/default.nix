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
    rev = "5a8172b428c5b096ddec9a4b50f7043e2edb8c33";
    sha256 = "sha256-2f83C69Y1iYi2zK79+zWDbhNKwJhxdJFwMbl+jP9NKY=";
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
