{ stdenv, fetchurl
, meson, ninja, pkgconfig
, boost, gmp, rapidjson, intervalset, loguru, redox, cppzmq, zeromq
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsched";
  version = "master";
  src = builtins.fetchurl "https://framagit.org/batsim/batsched/repository/master/archive.tar.gz";

  unpackPhase = ''
    tar xf $src

    local parsed_commit=$(ls | sed -n -E 's/^${pname}-master-([[:xdigit:]]{40})$/\1/p')
    echo "git commit seems to be $parsed_commit (parsed from extracted archive directory name)"

    cd ${pname}-master-$parsed_commit
    local version_name="commit $parsed_commit (built by Nix from master branch)"
    echo "overriding meson's version: $version_name"
    sed -iE "s/version: '.*',/version: '$version_name',/" meson.build
  '';

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ boost gmp rapidjson intervalset loguru redox cppzmq zeromq ];
  mesonBuildType = if debug then "debug" else "release";
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
