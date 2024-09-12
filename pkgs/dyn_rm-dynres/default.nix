{ lib
, python3
, fetchFromGitLab
, pmix
, openmpi-dynres
, dyn_psets
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dyn-rm";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "dyn_rm";
    rev = "cbb5e224554aac98d04d26e4c3ad057787cdf85a";
    hash = "sha256-Vu0gAIlY2IFqIoxxnY1b/ZScyDn6TscllVWXXqMxagM=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    openmpi-dynres
    dyn_psets
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pyyaml
    pmix
    dyn_psets
  ];

  doCheck = false;

  preBuild = ''
    substituteInPlace examples/timestamps/timestamps.c --replace "long ts1, ts2" "long ts1 = 0, ts2 = 0"
    substituteInPlace examples/Makefile --replace "-L./timestamps" "-L$out/examples/timestamps"

    substituteInPlace examples/submissions/sleep_expand_dynrm_nb.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"
    substituteInPlace examples/submissions/sleep_expand_dynrm_nb.batch --replace "build" $out/examples  

    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_bs_1.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"  
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_bs_1.batch --replace "build" $out/examples

    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_gs_1.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_gs_1.batch --replace "build" $out/examples

    substituteInPlace examples/submissions/mix1.mix --replace "/opt/hpc/build/dyn_rm" $out

    cd examples
    mkdir build
    make timestamps
    mkdir -p $out/examples/timestamps
    cp timestamps/libtimestamps.so $out/examples/timestamps
    make bench_sleep
    cp build/bench_sleep $out/examples
    cp -a run_test_dynrm.py submissions topology_files $out/examples
    cd ..
  '';

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/dyn-procs/dyn_rm";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
