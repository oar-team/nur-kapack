{ lib
, stdenv
, python3
, fetchFromGitLab
, dyn_rm-dynres
, openmpi-dynres
, dyn_psets
, writers
, pypmix-dynres
, timestamps
}:

stdenv.mkDerivation rec {
  pname = "mpdata3d";
  version = "0.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "mpdata3d";
    rev = "cf9df51a9ffa8d42c0d0d76e86d76bc8cd6f6e57";
    hash = "sha256-uWXugsN6pWb9aFFxNY0V6iKoOvB0+9wOhgwEo9kUgo4=";
  };

  nativeBuildInputs = [
    dyn_psets
    timestamps
  ];

  propagatedBuildInputs = [
    openmpi-dynres

  ];

  doCheck = false;

  buildPhase = ''
    cd submissions
    for prog_script in *.sh
    do
      sed -i 's/$SCRIPT_DIR\/..\/build\///g' $prog_script
      sed -i 's/$SCRIPT_DIR\/..\/output/\/tmp/g' $prog_script
    done
    #substituteInPlace mix1.mix --replace "/opt/hpc/build/dyn_rm/examples" $out
    #substituteInPlace mix2.mix --replace "/opt/hpc/build/dyn_rm/examples" $out
    cd ..      
    make MPI=${openmpi-dynres} DYN_PSETS=${dyn_psets} TIMESTAMPS=${timestamps}
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
      #mkdir -p $out/timestamps
      #cp timestamps/libtimestamps.so $out/timestamps
      mkdir -p $out/bin
      cp build/mpdata3d-nb $out/bin
      cp -r submissions topology_files $out
      ln -s ${run_test_dynrm}/bin/run_test_dynrm $out/run_test_dynrm
    '';

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/applications/mpdata3d";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
