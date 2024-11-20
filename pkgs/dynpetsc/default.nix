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
    rev = "d2439464652a554df6805e9369c43a11f1a9bd4c";
    sha256 = "sha256-3b7p5XXo5jeLIvlbeJJp/CpwxylATMKma1EHQ0ihqws=";
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
    "--with-debugging=0"
    "--with-mpi=1"
    "--with-mpiexec=${openmpi-dynres}/bin/mpiexec"
  ];
  
  configureScript = "python ./configure";
  
  meta = with lib; {
    description = "Dynamic version of PETSc numerical library.";
    homepage = "https://gitlab.inria.fr/dynres/applications/p4est_dyn";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Hubert
    platforms = platforms.linux;
  };
}
