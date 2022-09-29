{ config, stdenv, lib, fetchgit, autoreconfHook, which, gsl, postgresql, libmysqlclient, useOar ? true, slurm, useSlurm ? false, openmpi, useMysql ? true, useAvx512 ? config.useAvx512 or false, cudaSupport ? config.cudaSupport or false, cudatoolkit }:
# TODO test/finish OAR
# TODO test cudasupport
# TODO test/finish Postgresql
# TODO test/finish Slurm
# TODO test/add debug (test generic approach)
# TODO torque/PBS
# TODO remove workaround for "stack smashing detected" 
stdenv.mkDerivation rec {
  pname =  "ear";
  version = "4.1.0";

  # WARNNING: repo below refers to a private repository
  src = builtins.fetchGit {
    url = "ssh://git@gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/ear.git";
    rev = "6ec22df09f4d87c206075d3b7e0acd3c313f3bcc";
    narHash = "sha256-DNnEVrMWECI3j3VfjdmlB+75cSjyWvCpfzFgwHb2ZyA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gsl openmpi which ] ++ [(if useMysql then libmysqlclient else postgresql)] ++ lib.optional cudaSupport cudatoolkit ++ lib.optional useSlurm slurm;

  preConfigure = (if useMysql then ''
    mkdir mysql
    ln -s ${libmysqlclient.out}/lib mysql
    ln -s ${lib.getDev libmysqlclient}/include mysql
  '' else "") + (if useSlurm then
  ''
    mkdir slurm
    ln -s ${slurm.out}/lib slurm
    ln -s ${lib.getDev slurm}/include slurm
  '' else "");

  # 2022-05-17: workaround for "stack smashing detected" 
  NIX_CFLAGS_COMPILE = "-fno-stack-protector";
  
  configureFlags = [
    "CC=${stdenv.cc}/bin/gcc"
    "CC_FLAGS=-lm" # "CC_FLAGS=-DSHOW_DEBUGS"]
    "MPI_VERSION=ompi"
    "DB_DIR=/only_as_build_dep"
    "--with-gsl=${gsl.out}" ]
    ++ lib.optional useOar "--with-oar"
    ++ lib.optional useSlurm "--with-slurm=slurm"
    ++ [(if useMysql then "--with-mysql=mysql" else "--with-pgsql=${postgresql.out}")]
    ++ (if useAvx512 then ["--disable-avx512"] else ["--disable-avx512"])
    ++ (if cudaSupport then ["--with-cuda=${cudatoolkit.out}"] else []);
  #++ [(if useMysql then "--with-mysql=${libmysqlclient.out}" else "--with-pgsql=${postgresql.out}")]

  preBuild = if useMysql then ''
    makeFlagsArray=(DB_LDFLAGS="-lmysqlclient -L${libmysqlclient.out}/lib/mysql")
  '' else "";

  # compile ejob
  postBuild = ''
    export SRC=$PWD/src
    cd etc/examples/prolog_epilog
    make SRC=$SRC CC=${stdenv.cc}/bin/gcc CFLAGS=-lm
    cd -
  '';

  postInstall = "cp etc/examples/prolog_epilog/ejob etc/examples/prolog_epilog/oar-ejob $out/bin/";

  meta = with lib; {
    #broken = true;
    homepage = "https://gitlab.bsc.es/ear_team/ear";
    description = "Energy Aware Runtime (EAR) package provides an energy management framework for super computers";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
