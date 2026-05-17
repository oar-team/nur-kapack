{ lib
, stdenv
, python3
, fetchFromGitLab
, dyn_rm-dynres
, openmpi-dynres
, writers
, pypmix-dynres
, timestamps
, gptune-dynres
, mpi4py-dynres
}:

stdenv.mkDerivation rec {
  pname = "gptune-examples-dynres";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "gptune_examples";
    rev = "baceac997ff349f0d5d5f3a947bd7ad1445605bf";
    hash = "sha256-Z3elIKDC+j5KBzjO9/HxhtHPwYRrNDhfyRVj62G0vv8=";
  };

  nativeBuildInputs = [
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
    substituteInPlace mix1.mix --replace "/opt/hpc/build/dyn_rm/examples" $out
    substituteInPlace mix2.mix --replace "/opt/hpc/build/dyn_rm/examples" $out
    cd ..
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
      cp -r submissions topology_files $out
      ln -s ${run_test_dynrm}/bin/run_test_dynrm $out/run_test_dynrm
    '';

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/applications/dynrm_examples";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
