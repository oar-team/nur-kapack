{ lib
, python3
, fetchFromGitLab
, pmix
, openmpi-dynres
, dyn_psets
, pypmix  
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
    rev = "08218762419d1cbd07d660a78fc40f2919a21467";
    hash = "sha256-p6ZwrcJ1xLdnHj046/RG8USFOZeAcZ7qj/az6OoENvE=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    openmpi-dynres
    dyn_psets
    pypmix
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pyyaml
    pmix
    dyn_psets
    pypmix
  ];

  doCheck = false;

  preBuild = ''
    substituteInPlace examples/submissions/sleep_expand_dynrm_nb.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"
    substituteInPlace examples/submissions/sleep_expand_dynrm_nb.batch --replace "build" $out/examples  
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_bs_1.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"  
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_bs_1.batch --replace "build" $out/examples
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_gs_1.batch --replace "/opt/hpc/build/dyn_rm/examples/output" "/tmp"
    substituteInPlace examples/submissions/sleep_replace_dynrm_nb_gs_1.batch --replace "build" $out/examples
    substituteInPlace examples/submissions/mix1.mix --replace "/opt/hpc/build/dyn_rm" $out

    cd examples
    mkdir build 
    make MPI=${openmpi-dynres} DYN_PSETS=${dyn_psets}

    mkdir -p $out/examples/timestamps
    cp timestamps/libtimestamps.so $out/examples/timestamps
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
