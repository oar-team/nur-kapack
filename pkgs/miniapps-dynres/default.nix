{ lib, stdenv, fetchFromGitLab, gfortran, openmpi-dynres
} :

stdenv.mkDerivation rec {
  pname = "miniapps";
  version = "0.0.0";
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "5cf494d9ffc6cb7bd279cc57ca1493d4543e7b72";
    sha256 = "sha256-Hcl7+LX1FNSdLhpntymRotek+qZNeqD+azpBWMTQvLM=";
  };

  postPatch = ''
    substituteInPlace dyn_mpi_sessions_test_all.sh --replace "-x LD_LIBRARY_PATH -x DYNMPI_BASE \$DYNMPI_BASE/build/test_applications/build/" " "
    substituteInPlace dyn_mpi_sessions_test_all.sh --replace "-b 0" " "
    substituteInPlace dyn_mpi_sessions_test_all_8nodes.sh --replace "-x LD_LIBRARY_PATH -x DYNMPI_BASE \$DYNMPI_BASE/build/test_applications/build/" " "
    substituteInPlace dyn_mpi_sessions_test_all_8nodes.sh --replace "-b 0" " "
  '';

  nativeBuildInputs = [ openmpi-dynres gfortran ];

  buildInputs = [ ];

  buildPhase = ''
    mpic++ -o build/DynMPISessions_v2a_release -O3 -mtune=native -std=gnu++11 -DNDEBUG examples/dyn_mpi_sessions_v2a.cpp 
    mpic++ -o build/DynMPISessions_v2a_nb_release -O3 -mtune=native -std=gnu++11 -DNDEBUG examples/dyn_mpi_sessions_v2a_nb.cpp 
    mpif90 -o build/DynMPISessions_v2a_fortran_release -ffree-line-length-none -cpp -O3 -mtune=native ./examples/util.f90 ./examples/dyn_mpi_sessions_v2a.f90
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp -a build/* $out/bin
    cp dyn_mpi_sessions_test_all_8nodes.sh dyn_mpi_sessions_test_all.sh $out/bin
  '';

  meta = with lib; {
    description = "Time-X EuroHPC project: miniapps";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

