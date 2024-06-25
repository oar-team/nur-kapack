{ stdenv, lib, fetchFromGitHub, cmake, simgrid, cppzmq, python3, zeromq
, debug ? false
, optimize ? (!debug)
}:

with lib;

let
  optionOnOff = option: if option then "on" else "off";
in

stdenv.mkDerivation rec {
  pname = "elastisim";
  version = "master";

  src = fetchFromGitHub {
    owner  = "elastisim";
    repo   = "elastisim";
    rev    = "${version}";
    sha256 = "sha256-WWHXp3aLJ5X8RV6wbkaujX+C949mO6VLxEPuBfHA9tU=";
  };

  propagatedBuildInputs = [ ];
  nativeBuildInputs = [ cmake python3 simgrid cppzmq zeromq ];

  # "Release" does not work. non-debug mode is Debug compiled with optimization
  cmakeBuildType = "Debug";
  cmakeFlags = [
  ];
  makeFlags = optional debug "VERBOSE=1";

  installPhase = ''
    mkdir -p $out/bin
    cp elastisim $out/bin
  '';

  dontStrip = debug;

  meta = {
    description = "Batch-system simulation for elastic workloads";
    longDescription = ''
    '';
    homepage = "https://github.com/elastisim/elastisim";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ adfaure ];
    platforms = platforms.all;
    broken = false;
  };
}
