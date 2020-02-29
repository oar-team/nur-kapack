{ stdenv, fetchurl
, cmake
, boost, gmp, rapidjson, intervalset, loguru, redox, cppzmq, zeromq
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsched";
  version = "1.3.0";

  src = fetchurl {
    url = "https://framagit.org/batsim/batsched/repository/v${version}/archive.tar.gz";
    sha256 = "033m3b6ws5mx0q4sm04j4nn6zlssa33n5ips10p2ssvv5dxl5jls";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost gmp rapidjson intervalset loguru redox cppzmq zeromq ];
  cmakeBuildType = if debug then "Debug" else "Release";
  dontStrip = debug;

  meta = with stdenv.lib; {
    description = "Batsim C++ scheduling algorithms.";
    longDescription = "A set of scheduling algorithms for Batsim (and WRENCH).";
    homepage = "https://gitlab.inria.fr/batsim/batsched";
    platforms = platforms.unix;
    license = licenses.free;
    broken = false;
  };
}
