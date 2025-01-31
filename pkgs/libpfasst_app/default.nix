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
    rev = "2cefe8bfbf18cafa35643bac3b18d5af46ac816d";
    sha256 = "sha256-fzvRgnrb8nIuR6hniwL1K5vRyQ4DRZUoDGt4E7FxN70=";
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
        cd ../app
        mkdir build
        make all -d
          MPI=${openmpi-dynres} \
          HYPRE=${hypre}/lib/libHYPRE.a \ 
				  LIBPFASST=${libpfasst}/lib/libpfasst.a \
    			TIMESTAMPS=${timestamps}
          INSTALL_DIR=./
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
