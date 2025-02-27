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
    rev = "41c25383130dff11d57dcc3df86bc33fcb1f345b";
    sha256 = "sha256-jT6iyg7Zr7CtlZ6fMorFuCAX7D62hzHY370yxI/WThE=";
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
