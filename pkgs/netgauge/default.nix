{ lib
, stdenv
, fetchFromGitHub
, openmpi
}:

stdenv.mkDerivation rec {
  pname = "netgauge";
  version = "main";

  src = fetchFromGitHub {
    owner = "spcl";
    repo = "netgauge";
    rev = "f3ef494cc84cac836ffd95615a1167d5234cd39a";
    hash = "sha256-kmS1GS0w0lH0neueKY1cuD2iutC6uLME4M93JylObmc=";
  };


  buildInputs = [ openmpi ];

  preConfigure = ''
    export CC=mpicc
    export CXX=mpicxx
    export HRT_ARCH=2
  '';

  configureFlags = [ "--with-mpi" ];

  meta = with lib; {
    description = "Network benchmarking and LogGOP measurement tool";
    homepage = "https://htor.inf.ethz.ch/research/netgauge/";
    platforms = platforms.linux;
  };
}
