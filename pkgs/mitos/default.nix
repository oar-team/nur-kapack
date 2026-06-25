{ lib
, stdenv
, fetchFromGitHub
, cmake
, dyninst
, hwloc
, numactl
, mpi
, papi
, sys-sage
, boost
, libxml2
, onetbb
, elfutils
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "mitos";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "caps-tum";
    repo = "mitos";
    rev = "8b11b251c3cde6076c0b838a92b1aedb94f7af64";
    hash = "sha256-3dSRySb9J/uBkIb5W/D9r+5TSOAmc7DBgPqwxWotcjg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    dyninst
    hwloc
    numactl
    mpi
    papi
    sys-sage
    boost
    libxml2
    onetbb
    elfutils
    nlohmann_json
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${libxml2.dev}/include/libxml2"
  ];
  #cmakeFlags = [
  #  "-DCMAKE_PREFIX_PATH=${nlohmann_json}"
  #];

  patches = [
    ./lohmann.patch
  ];


  #dontUseCmakeConfigure = true;

  #configurePhase = ''
  #  ls -la
  #  echo "==="
  #  mkdir -p build
  #  cd build
  #  ls -la
  #  echo "==="
  #  ls -la ..

  #  cmake \
  #    -DCMAKE_BUILD_TYPE=Release \
  #    -DCMAKE_INSTALL_PREFIX=$out \
  #    ..
  #'';

  #buildPhase = ''
  #  cmake --build build -j $NIX_BUILD_CORES
  #'';

  #installPhase = ''
  #  cmake --install build
  #'';

  meta = with lib; {
    description = "Library and tool for collecting sampled memory performance data to view with MemAxes";
    homepage = "https://github.com/caps-tum/mitos";
    license = licenses.bsd3; # adjust if different
    platforms = platforms.linux;
  };
}
