{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "sowing";
  version = "0.0.0";

  src = fetchurl {
    url = "http://wgropp.cs.illinois.edu/projects/software/sowing/sowing.tar.gz";
    sha256 = "1gcj9yavv41ff8msl300ch28p789f4jhk49c09r55hvqcgsyn12x";
  };
  
  meta = with lib; {
    description = "Sowing MPICH: a Portable Environment for Parallel Scientific Computing";
    homepage = "http://wgropp.cs.illinois.edu/projects/software/sowing";
    #license = licenses.;
    #maintainers = [  ]; # Olivier Richard
    platforms = platforms.linux;
  };
}
