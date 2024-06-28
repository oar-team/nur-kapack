{ stdenv, lib, fetchurl, openmpi, automake }:

stdenv.mkDerivation rec {
  name = "NetPIPE-${version}";
  version = "3.7.2";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/netpipe/${version}-9/netpipe_${version}.orig.tar.gz";
    sha256 = "13dac884ff52951636f651c421f5ff4a853218a95aa28a4a852402ee385a2ab8";
  };

  nativeBuildInputs = [ openmpi automake ];

  buildPhase = ''
    mkdir -p $out/bin
    make mpi
  '';

  installPhase = ''
    ls
    for f in NP*
    do
      echo "$f" "$out/bin/$f"
      cp "$f" "$out/bin/$f"
    done
  '';

  meta = with lib; {
    description = ''
      NetPIPE (Network Protocol Independent Performance Evaluator) is a tool that
      provides a standard, configurable, and comprehensive way to measure the
      performance of network protocols. It can be used to measure point-to-point
      bandwidth and latency.
    '';
    homepage = "https://linux.die.net/man/1/netpipe";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
