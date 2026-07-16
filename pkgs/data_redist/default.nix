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
    rev = "5109618589187a9c6be841ae7ed9d9e3e4fccb66";
    sha256 = "sha256-6OBvdzkmqGpmJ8Tse6eS8a2gY4LuXZcxXkEebQm32fw=";
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

    dontStrip = true;
    
  postInstall = ''
      make bin/bench_redist_alltoallv INSTALL_DIR=$out \
        LDFLAGS="-L${mitos}/lib -lmitos -lmitoshooks -Wl,-rpath,${mitos}/lib"
      install -Dm555 bin/bench_redist_alltoallv $out/bin/bench_redist_alltoallv
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
