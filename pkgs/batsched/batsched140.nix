{ stdenv, fetchurl
, meson, ninja, pkgconfig
, boost, gmp, rapidjson, intervalset, loguru, redox, cppzmq, zeromq
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsched";
  version = "1.4.0";

  src = fetchurl {
    url = "https://gitlab.inria.fr/batsim/batsched/repository/v${version}/archive.tar.gz";
    sha256 = "1d6f22h76x18gx7dgz47424why6q0hnhbrjm529fys7ha384s8nh";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ boost gmp rapidjson intervalset loguru redox cppzmq zeromq ];
  mesonBuildType = if debug then "debug" else "release";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Batsim C++ scheduling algorithms.";
    longDescription = "A set of scheduling algorithms for Batsim (and WRENCH).";
    homepage = "https://gitlab.inria.fr/batsim/batsched";
    platforms = platforms.unix;
    license = licenses.free;
    broken = false;
  };
}
