{ lib, stdenv, fetchFromGitLab, scons, gfortran, openmpi-dynres
} :

stdenv.mkDerivation rec {
  pname = "miniapps";
  version = "0.0.0";
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    #rev = "ec96341aae5b30b9e4348972f46a8478443fc8b7";
    #sha256 = "sha256-7HgSDaGfWSdJtaKlCHweiW1yE7AIftvTgdM1br8B7gY=";
    rev = "204f360206030930cef7185f5258aac21c89f334";
    sha256 = "sha256-F3K2wP0LRVY4mDrPqGEtxrmUCzAJSANaE9Mt72Kk08Q=";
  };

  postPatch = ''
    #substituteInPlace SConstruct --replace "/usr/bin/g++" "g++"
    #substituteInPlace SConstruct --replace "['include']" "'${openmpi-dynres}/include'"
    substituteInPlace dyn_mpi_sessions_test_all.sh --replace "-x LD_LIBRARY_PATH -x DYNMPI_BASE \$DYNMPI_BASE/build/test_applications/build/" " "
    substituteInPlace dyn_mpi_sessions_test_all_8nodes.sh --replace "-x LD_LIBRARY_PATH -x DYNMPI_BASE \$DYNMPI_BASE/build/test_applications/build/" " "
  '';

  nativeBuildInputs = [ scons openmpi-dynres gfortran ];

  buildInputs = [ ];

  buildPhase = ''
    #export LD_LIBRARY_PATH=${openmpi-dynres}/lib 
    mpic++ -o build/DynMPISessions_v2a_release -O3 -mtune=native -std=gnu++11 -DNDEBUG examples/dyn_mpi_sessions_v2a.cpp 
    mpic++ -o build/DynMPISessions_v2a_nb_release -O3 -mtune=native -std=gnu++11 -DNDEBUG examples/dyn_mpi_sessions_v2a_nb.cpp 
    
    #scons example=DynMPISessions_v2a compileMode=release
    #scons example=DynMPISessions_v2a_nb compileMode=release
    #scons example=DynMPISessions_v2a_fortran compileMode=release
    mpif90 -o ./build/dyn_mpi_sessions_v2a_fortran -ffree-line-length-none -cpp -O3 -mtune=native ./examples/util.f90 ./examples/dyn_mpi_sessions_v2a.f90
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

