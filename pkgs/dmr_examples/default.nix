{ lib
, stdenv
, fetchFromGitLab
, dmr
, timestamps
, data_redist
, mkl
, openmpi
, writers
, dyn_rm-dynres
, pypmix-dynres  
}:

stdenv.mkDerivation rec {
  pname = "dmr_examples";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "d156768db53f133b2a117f48d76b6d9176700c4e";
    sha256 = "sha256-AYRz5zpbmPILcirTvyvGDEHj7AUVhF5NqFrNQUHqkQ0=";
  };

  nativeBuildInputs = [
    dmr
    timestamps
    data_redist
    mkl
    openmpi
  ];
  
  buildPhase = ''
    cd submissions
    for prog_script in *.sh
    do 
      sed -i 's/$SCRIPT_DIR\/..\/build\///g' $prog_script
      sed -i 's/$SCRIPT_DIR\/..\/output/\/tmp/g' $prog_script
    done
    cd ..
    REDIST_PATH=${data_redist} DMR_PATH=${dmr} TIMESTAMPS_PATH=${timestamps} MKL_PATH=${mkl} make all
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
    description = "Example applications using DMR with DynRM.";
    homepage = "https://gitlab.inria.fr/dynres/applications/dmr_examples";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
