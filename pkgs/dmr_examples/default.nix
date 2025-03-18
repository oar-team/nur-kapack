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
    rev = "7206238c6378d31a634b86e35271101ea4011b4f";
    sha256 = "sha256-cn/etXK1txynArkp4pObF9GWTL/az2VdviaarLoOm80=";
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
    make all REDIST=${data_redist} DMR=${dmr} TIMESTAMPS=${timestamps} MKL=${mkl}
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
