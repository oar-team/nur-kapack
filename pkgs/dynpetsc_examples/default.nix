{ lib
, stdenv
, fetchFromGitLab
, writers  
, openmpi-dynres  
, dynpetsc
, timestamps
, dyn_rm-dynres
, pypmix-dynres  
}:

stdenv.mkDerivation rec {
  pname = "dynpetsc_examples";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "7c00ade5e7ef94bfda7f19d0a91bb78ba17e9457";
    sha256 = "sha256-gJngqCqALVY4fmwwplWTUdv1aYDVtrVYfguEBMvWqP4=";
  };

  nativeBuildInputs = [
    openmpi-dynres  
    dynpetsc
    timestamps
  ];
  
  buildPhase = ''
    cd submissions
    sed -i 's/$SCRIPT_DIR\/..\/build\///g' petsc_ts.sh
    cd ..
    make all MPI=${openmpi-dynres} \
      DYN_PETSC=${dynpetsc} \
			TIMESTAMPS=${timestamps}
  '';

   installPhase = let
     run_test_dynrm = writers.writePython3Bin "run_test_dynrm" {
      # Need to fix run_test_dynrm.py
      flakeIgnore = [
        "E127" "E203" "E222" "E225" "E226" "E231" "E251" "E261" "E271"
        "E302" "E303" "F401" "F403" "F405" "E501" "W291" "W292" "W293" ];
      libraries = [
        dyn_rm-dynres
        pypmix-dynres
      ];
    } (lib.fileContents "${src}/run_test_dynrm.py");
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
