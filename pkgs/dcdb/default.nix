{ config, stdenv, scylladb-cpp-driver, lib, fetchurl, fetchgit, snap7,  boost170, cassandra, libuv, openssl, mosquitto-dcdb, libgcrypt, bacnet-stack, libgpg-error, freeipmi, net-snmp, opencv, mariadb-connector-c, mariadb, wget, git , unzip}:

stdenv.mkDerivation rec {
  pname =  "dcdb";
  version = "0.5";
  
  #src = fetchgit {
  #   url = "https://gitlab.lrz.de/dcdb/dcdb.git";
  #   rev = "ac0d755402ec76daa5fb58fdf4438d217acbb1d2";
  #   sha256 = "sha256-01d1a0uOHij4SiaaJQ0RDbMp0kDuKLSGEtgNEU95VmA=";
  #};
  src = fetchurl {
    name = "${pname}-${version}.zip";
    url = "https://gitlab.lrz.de/dcdb/dcdb/-/archive/${version}/${pname}-${version}.zip";
    sha256 = "sha256-TvxikYWHf4xqGnBSaHwBuz5+FwYVsty98J1D7x4+x4U="; 
  };

  buildInputs = [ boost170 cassandra bacnet-stack libuv scylladb-cpp-driver openssl mosquitto-dcdb libgcrypt libgpg-error freeipmi net-snmp opencv mariadb-connector-c mariadb snap7 wget git unzip ];

  propagatedBuildInputs = [ mariadb ];

  BACNET_SRC = "${bacnet-stack}";
  parentDir = "DCDB";

  unpackPhase = ''
    runHook preUnpack
    mkdir -p ${parentDir}
    unzip $src -d ${parentDir}
    runHook postUnpack
  '';
 
  preBuild = ''
    substituteInPlace ${parentDir}/${pname}-${version}/config.mk \
        --replace 'include $(DCDBSRCPATH)/dependencies.mk' '#include $(DCDBSRCPATH)/dependencies.mk' \
        --replace "-Wno-unused-variable" "-Wno-unused-variable -I${bacnet-stack}/include -I${bacnet-stack}/include/ports/linux -I${scylladb-cpp-driver}/include -I${opencv}/include/opencv4 -I${mariadb-connector-c}/lib" \
        --replace "c++17" "c++14" 
    substituteInPlace ${parentDir}/${pname}-${version}/dcdbpusher/sensors/bacnet/BACnetClient.h --replace "bacnet/" ""
    substituteInPlace ${parentDir}/${pname}-${version}/dcdbpusher/sensors/bacnet/BACnetClient.cpp --replace "bacnet/" ""
    substituteInPlace ${parentDir}/${pname}-${version}/dcdbpusher/sensors/bacnet/BACnetSensorBase.h --replace "bacnet/" ""
    substituteInPlace ${parentDir}/${pname}-${version}/dcdbpusher/includes/SensorGroupTemplate.h --replace "#include <memory>" \
    "#include <memory>
    #include <thread>"
    substituteInPlace ${parentDir}/${pname}-${version}/analytics/includes/OperatorTemplate.h --replace "#include <memory>" \
    "#include <memory>
    #include <thread>"
  '';

  buildPhase = ''
    runHook preBuild
    cd ${parentDir}/${pname}-${version}
    make depsinstall install 
    runHook postBuild
  '';
 
  meta = with lib; {
    homepage = "https://gitlab.lrz.de/dcdb/dcdb";
    description = "The Data Center Data Base (DCDB) is a modular, continuous and holistic monitoring framework targeted at HPC environments.";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
