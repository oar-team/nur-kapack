{ stdenv, fetchurl
, meson, ninja, pkgconfig
, simgrid, intervalset, boost, rapidjson, redox, hiredis, libev, zeromq, docopt_cpp, pugixml
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsim";
  version = "master";
  src = builtins.fetchurl "https://framagit.org/batsim/batsim/repository/master/archive.tar.gz";

  unpackPhase = ''
    # extract archive
    tar xf $src

    # as we suppose the archive has been obtained from gitlab on batsim's master branch,
    # the archive should contain a directory named "batsim-master-COMMIT".
    local parsed_commit=$(ls | sed -n -E 's/^batsim-master-([[:xdigit:]]{40})$/\1/p')
    echo "git commit seems to be $parsed_commit (parsed from extracted archive directory name)"

    # hack meson's default version
    cd batsim-master-$parsed_commit
    local version_name="commit $parsed_commit (built by Nix from master branch)"
    echo "overriding meson's version: $version_name"
    sed -iE "s/version: '.*',/version: '$version_name',/" meson.build
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
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

  mesonBuildType = if debug then "debug" else "release";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A batch scheduler simulator with a focus on realism that facilitates comparison.";
    homepage    = "https://github.com/oar-team/batsim";
    platforms   = platforms.unix;
    license = licenses.lgpl3;
    broken = false;

    longDescription = ''
      Batsim is a Batch Scheduler Simulator that uses SimGrid as the platform simulator.
    '';
  };
}
