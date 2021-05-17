{ stdenv
, meson, ninja, pkgconfig
, boost, gmp, rapidjson, intervalset, loguru, redox, cppzmq, zeromq
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsched";
  version = "master";
  src = builtins.fetchGit {
    url = "https://framagit.org/batsim/batsched.git";
    ref = "master";
  };

  patchPhase = ''
    local version_name="commit ${src.shortRev} (built by Nix from master branch)"
    echo "overriding meson's version: $version_name"
    sed -iE "s/version: '.*',/version: '$version_name',/" meson.build
  '';

  # Temporary hack. Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${stdenv.lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${stdenv.lib.getLib boost}/lib";

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ boost gmp rapidjson intervalset loguru redox cppzmq zeromq ];
  mesonBuildType = if debug then "debug" else "release";
  dontStrip = debug;

  meta = with stdenv.lib; {
    description = "Batsim C++ scheduling algorithms.";
    longDescription = "A set of scheduling algorithms for Batsim (and WRENCH).";
    homepage = "https://gitlab.inria.fr/batsim/batsched";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}
