{ lib
, python3
, fetchFromGitLab
, pmix
, openmpi-dynres
, dyn_psets 
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dyn-rm";
  version = "main-2024-06-13";
  pyproject = true;
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "dyn_rm";
    rev = "cbcc09150a1194f46b7138a61cfe9ab85a9df58d";
    hash = "sha256-8FtOEjqPa3OJp+AxqogdgKrDx5se2Evl6OZt9LLB680=";
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
