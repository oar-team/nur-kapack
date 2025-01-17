{ lib
, stdenv
, fetchFromGitLab
, writers
, openmpi-dynres
, p4est-dynres
, p4est-dyn
, timestamps
, dyn_rm-dynres
, pypmix-dynres
}:

stdenv.mkDerivation rec {
  pname = "p4est_dyn_examples";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "5a952841ae7ff578965965199bb3e9183b4ad385";
    sha256 = "sha256-S/xug1L2lhVhJdsnjdAbsLO9amsBfGmmJSz6wfpwTX8=";
  };

  nativeBuildInputs = [
    openmpi-dynres
    p4est-dynres

  ];

  buildPhase = ''
        cd submissions
        sed -i 's/$SCRIPT_DIR\/..\/build\///g' p4est_example.sh
        cd ..
        make all MPI=${openmpi-dynres} \
          P4EST=${p4est-dynres} \
    			DYN_P4EST=${p4est-dyn} \
    			TIMESTAMPS=${timestamps}
  '';

  installPhase =
    let
      run_test_dynrm = writers.writePython3Bin "run_test_dynrm"
        {
          # Need to fix run_test_dynrm.py
          flakeIgnore = [
            "E127"
            "E203"
            "E222"
            "E225"
            "E226"
            "E231"
            "E251"
            "E261"
            "E271"
            "E302"
            "E303"
            "F401"
            "F403"
            "F405"
            "E501"
            "W291"
            "W292"
            "W293"
          ];
          libraries = [
            dyn_rm-dynres
            pypmix-dynres
          ];
        }
        (lib.fileContents "${src}/run_test_dynrm.py");
    in
    ''
      mkdir -p $out/bin
      cp build/* $out/bin
      cp -a submissions topology_files $out
      ln -s ${run_test_dynrm}/bin/run_test_dynrm $out/run_test_dynrm
    '';


  meta = with lib; {
    description = "Example Application using Dynamic Resource Extensions for P4est.";
    homepage = "https://gitlab.inria.fr/dynres/applications/p4est_dyn_examples";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
