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
    rev = "2d27d4d108bbaa20e3794eefa8f43746bb9a0424";
    sha256 = "sha256-+2cpAZkEK3qCTci/v5RjbnMU6MVlBrqnHk9PMTScwcg=";
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
