{ lib
, stdenv
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "timestamps";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "utils";
    repo = pname;
    rev = "ba91e90504b85ddf6e48fab6b66f0e5db7b14b4e";
    sha256 = "sha256-tzBmCoG0B0RdUWMQdgZC2nSDuzMNmqraTk/7bNwtLxM=";
  };

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
