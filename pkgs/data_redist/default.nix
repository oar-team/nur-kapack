{ lib
, stdenv
, fetchFromGitLab
, openmpi

# optional dependencies (from Spack)
, mitos ? null
, enableTests ? false
, enableCheck ? false
, enableBenchmarks ? false
}:

assert !enableCheck || enableTests;
assert !enableBenchmarks || mitos != null;

stdenv.mkDerivation rec {
  pname = "data_redist";
  version = "0.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "utils";
    repo = pname;
    rev = "376bc749d0168d5c2715186b06885bd060784c5c";
    sha256 = "sha256-DSlIH1GblHNUAbEXnQRfpNb90m0Lf/s1OVT+lrya/Ao=";
  };

  nativeBuildInputs = [
    openmpi
  ];

  buildInputs = lib.optionals enableBenchmarks [
    mitos
  ];

  makeFlags = [
    "PREFIX=$out"
  ];

  buildPhase = ''
    runHook preBuild
    make all ${lib.concatStringsSep " " makeFlags}

    ${lib.optionalString enableTests ''
      make tests
    ''}

    ${lib.optionalString enableBenchmarks ''
      make benchmarks \
        LDFLAGS="-lmitos -lmitoshooks -L${mitos}/lib" \
        ${lib.concatStringsSep " " makeFlags}
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out

    ${lib.optionalString enableBenchmarks ''
      mkdir -p $out/bin
      install -Dm755 bin/bench_redist $out/bin/bench_redist
      install -Dm755 benchmarks/run_bench.sh $out/bin/run_bench.sh
    ''}

    runHook postInstall
  '';

  doCheck = enableTests && enableCheck;

  checkPhase = ''
    make check
  '';

  meta = with lib; {
    description = "Data redistribution library with MPI and non-MPI variants";
    homepage = "https://gitlab.inria.fr/dynres/utils/data_redist";
    platforms = platforms.linux;
  };
}
