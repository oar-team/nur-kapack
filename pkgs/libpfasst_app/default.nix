{ lib
, stdenv
, fetchFromGitLab
, writers
, openmpi-dynres
, libpfasst
, hypre  
, timestamps
, dyn_rm-dynres
, pypmix-dynres
}:

stdenv.mkDerivation rec {
  pname = "libpfasst_app";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "120ed912e34383506dcbf13bdc993ff377280af8";
    sha256 = "sha256-1Gw02RDYbnFe1p3Whbhh60/oeAe5ZiKdHXncpVG9k6M=";
  };

  nativeBuildInputs = [
    openmpi-dynres
    libpfasst
    hypre
    timestamps
  ];

  buildPhase = ''

        cd submissions
        sed -i 's/$SCRIPT_DIR\/..\/build\///g' libpfasst.sh
        cd ..
        mkdir build
        make all MPI=${openmpi-dynres} HYPRE=${hypre} LIBPFASST=${libpfasst} TIMESTAMPS=${timestamps}
        #cd ..
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
    description = "Example Application using Dynamic Resource Extensions for PetSc";
    homepage = "https://gitlab.inria.fr/dynres/applications/dynpetsc_examples";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
