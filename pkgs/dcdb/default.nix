{ config, stdenv, cpp-driver, lib, fetchgit, snap7,  boost170, cassandra, libuv, openssl, mosquitto, libgcrypt, bacnet-stack, libgpg-error, freeipmi, net-snmp, opencv, mariadb-connector-c, wget, git }:

stdenv.mkDerivation rec {
  name =  "dcdb-${version}";
  version = "0.4";
  
  # src = fetchgit {
  #   url = "https://gitlab.bsc.es/ear_team/ear.git";
  #   rev = "d7e206ab289efdbb25a00b408dea748536faeef2";
  #   sha256 = "sha256-ff/NdZ3jvHGxO4v92+KpzDpHhWcZKVmwuBLs/oZyl5I=";
  # };

  src = /home/imeignanmasson/DCDB/dcdb;

  #nativeInputs = [ cassandra bacnet-stack ];
  
  buildInputs = [ boost170 cassandra bacnet-stack libuv cpp-driver openssl mosquitto libgcrypt libgpg-error freeipmi net-snmp opencv mariadb-connector-c snap7 wget git ];

  BACNET_SRC = "${bacnet-stack}";
 
  preBuild = ''
    substituteInPlace config.mk \
        --replace 'include $(DCDBSRCPATH)/dependencies.mk' '#include $(DCDBSRCPATH)/dependencies.mk' \
        --replace "-Wno-unused-variable" "-Wno-unused-variable -I${bacnet-stack}/include" \
        --replace "c++17" "c++14"
  '';
 
  # apache-cassandra-3.11.5.tar.gz
  
  #buildInputs = [ gsl slurm openmpi ] ++ [(if useMysql then  libmysqlclient else postgresql)] ++ lib.optional cudaSupport cudatoolkit;

  #patches = [ ./Makefile.extra.patch ];

  #preConfigure = (if useMysql then ''
  
  #configureFlags = [
  
  #preBuild =;

  meta = with lib; {
    homepage = "https://gitlab.lrz.de/dcdb/dcdb";
    description = "The Data Center Data Base (DCDB) is a modular, continuous and holistic monitoring framework targeted at HPC environments.";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
