{ lib, stdenv, fetchFromGitLab, gfortran, perl, libnl
, rdma-core, zlib, numactl, libevent, hwloc, targetPackages
, libpsm2, libfabric, pmix, prrte, autoconf, automake, libtool, flex
, config
# Enable CUDA support
#, cudaSupport ? config.cudaSupport, cudatoolkit

  
# Enable the Sun Grid Engine bindings


# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false

# Enable libfabric support (necessary for Omnipath networks) on x86_64 linux
#, fabricSupport ? stdenv.isLinux && stdenv.isx86_64
, fabricSupport ? false
# Enable Fortran support
, fortranSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "openmpi-dynres";
  version = "5.1.0";
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "d2ed99a62a0c515bc4bde7e10c6d7a945c01aad1";
    sha256 = "sha256-yAfOnC29UN2orZ2nGxI/qj9k843Dgpc4/Tmz8atVkP0=";
  };

  postPatch = '' 
    #patchShebangs ./autogen.pl
    #patchShebangs ./config
    patchShebangs ./
  '';

  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isLinux [ libnl numactl pmix ]
    ++ [ libevent hwloc ]
    ++ lib.optional (stdenv.isLinux || stdenv.isFreeBSD) rdma-core
    ++ lib.optionals fabricSupport [ libpsm2 libfabric ];

  nativeBuildInputs = [ perl autoconf automake libtool flex]
    ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = lib.optional (!fortranSupport) "--disable-mpi-fortran"
    ++ lib.optionals stdenv.isLinux  [
      "--with-libnl=${libnl.dev}"
      "--with-pmix=${pmix}"
      "--with-pmix-libdir=${pmix}/lib"
      "--with-prrte=${prrte}"
      "--with-ucx=no"
    ] ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    ++ lib.optionals fabricSupport [ "--with-psm2=${libpsm2}" "--with-libfabric=${libfabric}" ]
  ;
  
  preConfigure = ''
    rm .gitmodules #no git submodule, pmix and prrte is provided as input
    ./autogen.pl
  '';

  enableParallelBuilding = true;

  postInstall = ''
    rm -f $out/lib/*.la
   '';

  postFixup = ''
    # default compilers should be indentical to the
    # compilers at build time

    sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
      $out/share/openmpi/mpicc-wrapper-data.txt
    '';
  #   sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
  #      $out/share/openmpi/ortecc-wrapper-data.txt

  #   sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' \
  #      $out/share/openmpi/mpic++-wrapper-data.txt
  # '' + lib.optionalString fortranSupport ''

  #   sed -i 's:compiler=.*:compiler=${gfortran}/bin/${gfortran.targetPrefix}gfortran:'  \
  #      $out/share/openmpi/mpifort-wrapper-data.txt
  # '';

  doCheck = true;


  meta = with lib; {
    homepage = "https://www.open-mpi.org/";
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
