{ stdenv, fetchurl
, meson, ninja, pkgconfig
, simgrid, intervalset, boost, rapidjson, redox, hiredis, libev, zeromq, docopt_cpp, pugixml
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsim";
  version = "3.1.0";

  src = fetchurl {
    url = "https://gitlab.inria.fr/batsim/batsim/repository/v${version}/archive.tar.gz";
    sha256 = "0aa5b3bp7khazn7gyslczxydijigshxg5xf1284v31l28iq7mzvx";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];
  # runtimeDeps is used to generate multi-layered docker contained
  runtimeDeps = [
    simgrid
    intervalset
    boost
    rapidjson
    redox
    hiredis
    libev
    zeromq
    docopt_cpp
    pugixml
  ];
  buildInputs = runtimeDeps;

  mesonBuildType = if debug then "debug" else "release";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An infrastructure simulator that focuses on resource management techniques.";
    homepage = "https://framagit.org/batsim/batsim";
    platforms = platforms.unix;
    license = licenses.lgpl3;
    broken = false;

    longDescription = ''
      Batsim is an infrastructure simulator that enables the study of resource management techniques.
    '';
  };
}
