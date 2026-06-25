{ lib
, stdenv
, fetchFromGitHub
, cmake
, libxml2
, nlohmann_json
, hwloc ? null
, numactl ? null
, cudaPackages ? null

, nvidiaMig ? false
, cpuinfo ? true
, buildDataSources ? false
, dsHwloc ? false
, dsNuma ? false
}:

assert !buildDataSources || hwloc != null;
assert !buildDataSources || numactl != null;
assert !dsHwloc || hwloc != null;
assert !dsNuma || numactl != null;
assert !nvidiaMig || cudaPackages != null;

stdenv.mkDerivation rec {
  pname = "sys-sage";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "caps-tum";
    repo = "sys-sage";
    rev = "v${version}";
    hash = "sha256-Q4gnPOUrAbdPXQ6O1Eill4j3qfWAMob49t7ZN9oDL/8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [ 
    nlohmann_json 
    libxml2
  ];

  buildInputs =
    [
      libxml2
      nlohmann_json
    ]
    ++ lib.optionals (buildDataSources || dsHwloc) [
      hwloc
    ]
    ++ lib.optionals (buildDataSources || dsNuma) [
      numactl
    ]
    ++ lib.optionals (nvidiaMig || buildDataSources) [
      cudaPackages.cuda_cudart
    ];

  cmakeFlags =
    [
      (lib.cmakeBool "NVIDIA_MIG" nvidiaMig)

      (lib.cmakeBool "CPUINFO"
        (cpuinfo
          && stdenv.hostPlatform.isx86_64
          && stdenv.hostPlatform.isLinux))

      (lib.cmakeBool "DS_HWLOC"
        (dsHwloc || buildDataSources))

      (lib.cmakeBool "DS_NUMA"
        (dsNuma || buildDataSources))
    ];

  patches = [
    ./sys-sage-headers.patch
  ];

  meta = with lib; {
    description =
      "Library for capturing hardware topology and attributes of compute systems";

    homepage = "https://github.com/caps-tum/sys-sage";

    license = licenses.asl20;

    platforms = platforms.linux;

    maintainers = [ ];
  };
}
