{ lib
, stdenv
, python3
, fetchFromGitLab
, dyn_rm-dynres
, openmpi-dynres
, dyn_psets
}:

stdenv.mkDerivation rec {
  pname = "dyn-rm-examples";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "dynrm_examples";
    rev = "c356d13bd8b8228a257974cf65f028a2bd5fc2af";
    hash = "sha256-AHOxyVzJF1T15ruJ+SjpJnc8btJFSyCsNjHxy9fFtmw=";
  };

  nativeBuildInputs = [
    dyn_psets
  ];

  propagatedBuildInputs = [
    openmpi-dynres
  ];

  doCheck = false;

  preBuild = ''
    sed -i 's/$SCRIPT_DIR\/..\/build\///' submissions/sleep_expand_dynrm_nb.sh
    sed -i 's/$SCRIPT_DIR\/..\/output/\/tmp/' submissions/sleep_expand_dynrm_nb.sh
    sed -i 's/$SCRIPT_DIR\/..\/build\///' submissions/sleep_replace_dynrm_nb_bs_1.sh
    sed -i 's/$SCRIPT_DIR\/..\/output/\/tmp/' submissions/sleep_replace_dynrm_nb_bs_1.sh
    sed -i 's/$SCRIPT_DIR\/..\/build\///' submissions/sleep_replace_dynrm_nb_gs_1.sh
    sed -i 's/$SCRIPT_DIR\/..\/output/\/tmp/' submissions/sleep_replace_dynrm_nb_gs_1.sh
    
    substituteInPlace submissions/mix1.mix --replace "/opt/hpc/build/dyn_rm/examples" $out
    substituteInPlace submissions/mix2.mix --replace "/opt/hpc/build/dyn_rm/examples" $out

    make MPI=${openmpi-dynres} DYN_PSETS=${dyn_psets}

    mkdir -p $out/timestamps
    cp timestamps/libtimestamps.so $out/timestamps
    mkdir -p $out/bin
    cp build/bench_sleep $out/bin
    cp -a run_test_dynrm.py submissions topology_files $out
    cd ..
  '';

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/applications/dynrm_examples";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
