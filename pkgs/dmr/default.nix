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
    rev = "f5c3e5fe0dadf482b9f7171d50c6f51740559746";
    sha256 = "sha256-BwOZcRsfJcuP0zXZD5bMlW/qIT4pfUB8eOFYLU1o8ZI=";
  };

  nativeBuildInputs = [
    openmpi
  ];

  buildPhase = "make lib sleep";

  installPhase = ''
    make install INSTALL_DIR=$out
    mkdir -p $out/bin
    cp sleepOf $out/bin   
  '';

  meta = with lib; {
    description = "The European PILOT";
    homepage = "https://gitlab.bsc.es/siserte/dmr";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
