{ lib
, stdenv
, fetchFromGitLab
, openmpi
}:

stdenv.mkDerivation rec {
  pname = "dmr";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.bsc.es";
    owner = "siserte";
    repo = pname;
    rev = "f443123b52cfad490d1cf6987837cbaa7e152ef8";
    sha256 = "sha256-ylShp7QEfxaGC5hWoRvP/YXIxo5CXEUiC/W5vs2Djto=";
  };

  nativeBuildInputs = [
    openmpi
  ];

  buildPhase = "make lib sleep";

  installPhase = ''
    mkdir -p $out/bin
    cp sleepOf $out/bin
    mkdir -p $out/lib
    cp libdmr.so $out/lib
  ''; 
  
  meta = with lib; {
    description = "The European PILOT";
    homepage = "https://gitlab.bsc.es/siserte/dmr";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
