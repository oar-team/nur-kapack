{ config, stdenv, scylladb-cpp-driver, lib, fetchgit, snap7,  boost170, cassandra, libuv, openssl, mosquitto, libgcrypt, bacnet-stack, libgpg-error, freeipmi, net-snmp, opencv, mariadb-connector-c, wget, git }:

stdenv.mkDerivation rec {
  name =  "dcdb-${version}";
  version = "0.4";
  
  src = fetchgit {
     url = "https://gitlab.lrz.de/dcdb/dcdb.git";
     rev = "ac0d755402ec76daa5fb58fdf4438d217acbb1d2";
     sha256 = "sha256-01d1a0uOHij4SiaaJQ0RDbMp0kDuKLSGEtgNEU95VmA=";
  };

  #src = /home/imeignanmasson/DCDB/dcdb;

  #nativeInputs = [ cassandra bacnet-stack ];
  
  buildInputs = [ boost170 cassandra bacnet-stack libuv scylladb-cpp-driver openssl mosquitto libgcrypt libgpg-error freeipmi net-snmp opencv mariadb-connector-c snap7 wget git ];

  BACNET_SRC = "${bacnet-stack}";
 
  preBuild = ''
    substituteInPlace config.mk \
        --replace 'include $(DCDBSRCPATH)/dependencies.mk' '#include $(DCDBSRCPATH)/dependencies.mk' \
        --replace "-Wno-unused-variable" "-Wno-unused-variable -I${bacnet-stack}/include -I${scylladb-cpp-driver}/include" \
        --replace "c++17" "c++14" 
    substituteInPlace dcdbpusher/sensors/bacnet/BACnetClient.h --replace "bacnet/" ""
  '';
 
  meta = with lib; {
    homepage = "https://gitlab.lrz.de/dcdb/dcdb";
    description = "The Data Center Data Base (DCDB) is a modular, continuous and holistic monitoring framework targeted at HPC environments.";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
