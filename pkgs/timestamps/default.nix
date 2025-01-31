{ lib
, stdenv
, fetchFromGitLab
, gfortran
}:

stdenv.mkDerivation rec {
  pname = "timestamps";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "utils";
    repo = pname;
    rev = "142fd741c5ef3e724378008323ba4778a914cb52";
    sha256 = "sha256-Sq/zPsdCS93nj+am7WWokYCbSqi7MG2t6t12zQHVO/Y=";
  };

  nativeBuildInputs = [
    gfortran
  ];


  buildPhase = "make all";

  installPhase = ''
    mkdir -p $out
    make all install INSTALL_DIR=$out
  '';

  meta = with lib; {
    description = "This library provides a simple utility to create timestamps in iterative, dynamic applications.";
    homepage = "https://gitlab.inria.fr/dynres/utils/timestamps";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
