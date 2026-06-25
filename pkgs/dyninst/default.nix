{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, elfutils
, onetbb
, libiberty
, gccStdenv
, static ? false
, openmpSupport ? false
}:

stdenv.mkDerivation rec {
  stdenv = gccStdenv;

  pname = "dyninst";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "dyninst";
    repo = "dyninst";
    rev = "v13.0.0";
    sha256 = "sha256-ZYD4+ATLVstoqOiXfuhN9myrfHlOaO+sH8Fu/s1PbW4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    elfutils
    onetbb
    libiberty
  ];


  cmakeFlags = [
    "-DBoost_ROOT_DIR=${boost}"
    "-DElfUtils_ROOT_DIR=${elfutils}"
    "-DTBB_ROOT_DIR=${onetbb}"
    "-DLibIberty_ROOT_DIR=${libiberty}"
    "-DLibIberty_LIBRARIES=${libiberty}/lib/libiberty.a"

    "-DUSE_OpenMP=${if openmpSupport then "ON" else "OFF"}"
    "-DENABLE_STATIC_LIBS=${if static then "ON" else "OFF"}"
  ];

  # Dyninst 13 requires GCC according to the Spack recipe.
  # Nix uses stdenv to choose the compiler, so enforce that.
  #preConfigure = ''
  #  if [ "$CC" != "${stdenv.cc}/bin/gcc" ]; then
  #    echo "Dyninst 13 must be built with GCC"
  #    exit 1
  #  fi
  #'';

  doCheck = false;

  meta = with lib; {
    description = "API for dynamic binary instrumentation";
    homepage = "https://paradyn.org";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [];
  };
}
