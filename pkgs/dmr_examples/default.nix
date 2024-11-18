{ lib
, stdenv
, fetchFromGitLab
, dmr
, timestamps
, data_redist
, mkl
, openmpi  
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
  
  buildPhase = "REDIST_PATH=${data_redist} DMR_PATH=${dmr} TIMESTAMPS_PATH=${timestamps} MKL_PATH=${mkl} make all";
  
  installPhase = ''
      mkdir -p $out/bin
      cp build/* $out/bin
  ''; 
  
  meta = with lib; {
    description = "Example applications using DMR with DynRM.";
    homepage = "https://gitlab.inria.fr/dynres/applications/dmr_examples";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
