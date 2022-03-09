{ config, stdenv, lib, fetchgit, autoreconfHook, gsl, postgresql, libmysqlclient, slurm, openmpi, useMysql ? true, useAvx512 ? config.useAvx512 or false, cudaSupport ? config.cudaSupport or false, cudatoolkit }:

stdenv.mkDerivation rec {
  name =  "ear-${version}";
  version = "4.0.5";
  
  # src = fetchgit {
  #    url = "https://gitlab.bsc.es/ear_team/ear.git";
  #    rev = "d7e206ab289efdbb25a00b408dea748536faeef2";
  #    sha256 = "sha256-ff/NdZ3jvHGxO4v92+KpzDpHhWcZKVmwuBLs/oZyl5I=";
  # };

  #src = /home/orichard/ear;
  src = /home/auguste/dev/ear;
  
  nativeBuildInputs = [ autoreconfHook ];
  
  buildInputs = [ gsl slurm openmpi ] ++ [(if useMysql then libmysqlclient else postgresql)] ++ lib.optional cudaSupport cudatoolkit;

  patches = [ ./Makefile.extra.patch ];

  preConfigure = (if useMysql then ''
    mkdir mysql
    ln -s ${libmysqlclient.out}/lib mysql
    ln -s ${lib.getDev libmysqlclient}/include mysql
  '' else "") +
  ''
    mkdir slurm
    ln -s ${slurm.out}/lib slurm
    ln -s ${lib.getDev slurm}/include slurm
  '';

  configureFlags = [
    "CC=${stdenv.cc}/bin/gcc"
    "CC_FLAGS=-lm"
    "DB_DIR=/only_as_build_dep"
    "--with-gsl=${gsl.out}"
    "--with-slurm=slurm"]# "CC_FLAGS=-DSHOW_DEBUGS"]
    ++ [(if useMysql then "--with-mysql=${libmysqlclient.out}" else "--with-pgsql=${postgresql.out}")]
    ++ (if useAvx512 then [] else ["--disable-avx512"])
    ++ (if cudaSupport then ["--with-cuda=${cudatoolkit.out}"] else []);

  preBuild = if useMysql then ''
    makeFlagsArray=(DB_LDFLAGS="-lmysqlclient -L${libmysqlclient.out}/lib/mysql")
  '' else "";

  meta = with lib; {
    homepage = "https://gitlab.bsc.es/ear_team/ear";
    description = "Energy Aware Runtime (EAR) package provides an energy management framework for super computers";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
