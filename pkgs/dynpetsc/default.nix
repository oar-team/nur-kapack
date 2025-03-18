{ lib
, stdenv
, fetchFromGitLab
, openmpi-dynres
, openblas
, python3
, gfortran
, pkg-config
, sowing
}:

stdenv.mkDerivation rec {
  pname = "dynpetsc";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "b9c46891939f33192a8aa87e0a322319cac4aef2";
    sha256 = "sha256-mWgh2qt3+kTHzRl0PSU9KLhi8lmA2+G8k1eVdYMFrNg=";
  };

  nativeBuildInputs = [
    python3
    openmpi-dynres
    gfortran
    pkg-config
    sowing
  ];

  buildInputs = [
    openmpi-dynres
    openblas
  ];
  #buildInputs = [ blas lapack ];


  #enableParallelBuilding = true;
  preConfigure = ''
    patchShebangs ./lib/petsc/bin
  '';

  configureFlags = [
    "--with-blaslapack-include=${lib.getDev openblas}/include"
    "--with-blaslapack-lib=${openblas}/lib/libopenblas.so"
    "--known-64-bit-blas-indices=0"
    "--with-mpi-dir=${lib.getDev openmpi-dynres}"
    "--with-debugging=1"
    "--with-mpi=1"
    "--with-mpiexec=${openmpi-dynres}/bin/mpiexec"
  ];

  configureScript = "./configure";

  meta = with lib; {
    description = "Dynamic version of PETSc numerical library.";
    homepage = "https://gitlab.inria.fr/dynres/applications/p4est_dyn";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
