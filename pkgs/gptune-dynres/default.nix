{ stdenv
, lib
, cmake
, blas
, lapack
, scalapack-dynres
, openmpi-dynres
, mpi4py-dynres
, jq
, tbb
, python39
, python39Packages
, fetchFromGitLab ? null
, fetchpatch ? null
}:

let
  version = "2022.01.27";

  gptuneSrc = fetchFromGitLab {
    domain = "inria.gitlab.fr";
    owner = "dynres";
    group = "applications";
    repo = "GPTune";
    rev = "c0191b6ad9ae451d46bb1d212b28aab1563b419f";  # commit hash
    hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  };


  # ----------- Python package overrides / patches -------------
  gpyPatched = python39Packages.buildPythonPackage rec {
    pname = "gpy";
    version = "1.10.0";  # adapt to the version you need
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; # replace with real hash
    };
    patchPhase = ''
      cat ${./patches/GPy/coregionalize.py} > GPy/kern/src/coregionalize.py
      cat ${./patches/GPy/stationary.py} > GPy/kern/src/stationary.py
      cat ${./patches/GPy/choleskies.py} > GPy/util/choleskies.py
    '';
    meta.broken = false;
    doCheck = false;
  };

  scikitOptimizePatched = python39Packages.buildPythonPackage rec {
    pname = "scikit-optimize";
    version = "0.9.0";
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; # replace with real hash
    };
    patchPhase = "cat ${./patches/scikit-optimize/space.py} > skopt/space/space.py";
    disabledTests = ["utils" "test_space"];
    doCheck = false;
  };

  # ----------- Extra Python packages not in nixpkgs -------------
  cGP = python39Packages.buildPythonPackage rec {
    pname = "cGP";
    inherit version;
    src = builtins.fetchGit {
      url = "https://github.com/GPTune/cGP";
      ref = "main";
      rev = "1d5734b8fb35a7dadbf0b5b3f0077dc9c83527c9";
    };
    propagatedBuildInputs = with python39Packages; [ numpy gpyPatched scikit-learn scikitOptimizePatched scikit-optimize scipy dill ];
    doCheck = false;
    pythonImportsCheck = [ "cGP" ];
  };

  opentuner = python39Packages.buildPythonPackage rec {
    pname = "opentuner";
    version = "0.8.8";
    src = builtins.fetchGit {
      url = "https://github.com/jansel/opentuner";
      ref = "master";
      rev = "05e2d6b9538c9e2d335a02c48c0f7e77d1c57077";
    };
    patchPhase = "sed '1d' requirements.txt > requirements.txt";
    propagatedBuildInputs = with python39Packages; [ sqlite numpy sqlalchemy future ];
    buildInputs = [ python39Packages.setuptools ];
    doCheck = false;
  };

  autotune = python39Packages.buildPythonPackage rec {
    pname = "autotune";
    version = "2022.08.31";
    src = builtins.fetchGit {
      url = "https://github.com/gptune/autotune";
      ref = "master";
      rev = "58f5d9a39106e3b2dbdea9ebcbe928a1b65bea6a";
    };
    propagatedBuildInputs = with python39Packages; [ numpy setuptools scikitOptimizePatched ];
    doCheck = false;
    pythonImportsCheck = [ "autotune" ];
  };

  lhsmdu = python39Packages.buildPythonPackage rec {
    pname = "lhsmdu";
    version = "1.1";
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-S8Hfa5zdJ7rgv/dc8Wk/RVujLk+ofKmpMvYGlmB/5xI=";
    };
    propagatedBuildInputs = with python39Packages; [ numpy scipy ];
  };

  hpbandster = python39Packages.buildPythonPackage rec {
    pname = "hpbandster";
    version = "0.7.4";
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-Sf/DJogVW1CeYvNhe1KuFalsm/8smWoj34PyeRBsWSE=";
    };
    propagatedBuildInputs = with python39Packages; [ cGP ConfigSpace Pyro4 serpent numpy statsmodels scipy netifaces ];
    checkInputs = [ python39Packages.unittestCheckHook ];
    unittestFlags = [ "-s" "tests" "-v" ];
  };

  ConfigSpace = python39Packages.buildPythonPackage rec {
    pname = "ConfigSpace";
    version = "0.6.0";
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-m2yV2IOfyrIgNyZzIUsxKbRdzYsReYKessZXRsrLcqk=";
    };
    propagatedBuildInputs = with python39Packages; [ numpy scipy cython pyparsing typing-extensions ];
    checkInputs = [ python39Packages.pytest ];
  };

  SALib = python39Packages.buildPythonPackage rec {
    pname = "SALib";
    version = "1.4.5";
    src = python39Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-zzlhduMN7VetZ9DRVPkXaJ+Pc+9cwdzTjUeW9DYQ2SU=";
    };
    propagatedBuildInputs = with python39Packages; [ setuptools-scm numpy scipy matplotlib pandas multiprocess pathos ];
    doCheck = false;
  };

  extraPyPackages = [ cGP opentuner autotune lhsmdu hpbandster ConfigSpace SALib ];


  pydeps = with python39Packages; [
    joblib scikit-learn scipy statsmodels pyaml scikitOptimizePatched
    matplotlib gpy openturns ipyparallel pygmo filelock requests pymoo mpi4py-dynres cloudpickle
  ];

  # Helper to combine pydeps with a specific Python package
  fullPythonWith = pypkg: python39Packages.buildEnv.override {
    extraLibs = pydeps ++ [ pypkg ];
  };

  # ----------- gptune-libs (C/Fortran) -------------
  # GPTune C/Fortran libraries
  gptuneLibs = stdenv.mkDerivation rec {
    pname = "gptune-libs";
    inherit version;
    src = gptuneSrc;

    nativeBuildInputs = [ cmake ];
    buildInputs = [ blas lapack scalapack-dynres openmpi-dynres jq tbb python39Packages.python ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=ON"
      "-DCMAKE_CXX_COMPILER=mpicxx"
      "-DCMAKE_C_COMPILER=mpicc"
      "-DCMAKE_Fortran_COMPILER=mpif90"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DGPTUNE_INSTALL_PATH=${placeholder "out"}"
      "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
      "-DTPL_BLAS_LIBRARIES=${blas}/lib/libblas${stdenv.hostPlatform.extensions.sharedLibrary}"
      "-DTPL_LAPACK_LIBRARIES=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
      "-DTPL_SCALAPACK_LIBRARIES=${scalapack-dynres}/lib/libscalapack${stdenv.hostPlatform.extensions.sharedLibrary}"
    ] ++ lib.optionals stdenv.isDarwin [
      "-DCMAKE_Fortran_FLAGS=-fallow-argument-mismatch"
    ];

    postInstall = ''
      cat $src/setup.py > $out/setup.py
    '';
  };

  # GPTune Python package
  gptunePython = python39Packages.buildPythonPackage rec {
    pname = "GPTune";
    inherit version;
    src = gptuneSrc;
    propagatedBuildInputs = pydeps;
    doCheck = false;
  };

in {
  gptuneLibs = gptuneLibs;
  gptunePython = gptunePython;

  # Dev shell with full environment
  devShell = stdenv.mkDerivation {
    name = "gptune-dev";
    nativeBuildInputs = [ gptuneLibs (fullPythonWith gptunePython) blas lapack scalapack-dynres openmpi-dynres ];

    shellHook = ''
      export PYTHONWARNINGS=ignore
      export GPTUNEROOT=$PWD
      export GPTUNE_INSTALL_PATH=${gptuneLibs}/gptune/
      export PYTHONPATH=$PYTHONPATH:${gptuneLibs}/gptune/
      echo "GPTune dev shell ready!"
    '';
  };

  defaultPackage = gptuneLibs;
}

