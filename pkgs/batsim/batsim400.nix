{ stdenv, fetchurl
, meson, ninja, pkgconfig
, simgrid, intervalset, boost, rapidjson, redox, zeromq, docopt_cpp, pugixml
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsim";
  version = "4.0.0";

  src = fetchurl {
    url = "https://gitlab.inria.fr/batsim/batsim/repository/v${version}/archive.tar.gz";
    sha256 = "1kyhpmnpiff78p2cx0281ksbxc8m9c7n6hbxacfxn092kw6x0hl4";
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
    rapidjson
    redox
    zeromq
    docopt_cpp
    pugixml
  ];
  buildInputs = [
    boost
  ] ++ runtimeDeps;

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
