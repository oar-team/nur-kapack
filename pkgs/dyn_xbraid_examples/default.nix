{ lib
, stdenv
, fetchFromGitLab
, writers
, openmpi-dynres
, xbraid
, dyn-xbraid
, dmr
, timestamps
, dyn_rm-dynres
, pypmix-dynres
}:

stdenv.mkDerivation rec {
  pname = "dyn_xbraid_examples";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "f4a4eaf61fe512d5c612eb78059ba4a8cf16df36";
    sha256 = "sha256-Adp1Y6WWC8zCB+zLbZxk2SQPGPqnnYf5ggwHefmLbAg=";
  };

  buildInputs = [
    openmpi-dynres
    dyn-xbraid
    dmr
    timestamps
  ];

  buildPhase = ''
        cd submissions
        sed -i 's/$SCRIPT_DIR\/..\/build\///g' xbraid1D.sh
        cd ..
        make all MPI=${openmpi-dynres} \
    			DMR=${dmr} \
    			XBRAID=${xbraid} \
    			DYN_XBRAID=${dyn-xbraid} \
    			TIMESTAMPS=${timestamps} \
    			DEBUG=0
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
    description = "Example Application using Dynamic Resource Extensions for XBraid";
    homepage = "https://gitlab.inria.fr/dynres/applications/dyn_xbraid_examples";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
