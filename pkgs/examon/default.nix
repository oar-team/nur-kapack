{ config, stdenv, lib, fetchgit, openssl_1_0_2, libpfm, python3}:
stdenv.mkDerivation rec {
  pname =  "examon";
  version = "0.2.3";
  
  #WARNNING: repo below refers to a private repository
  src = builtins.fetchGit {
    url = "ssh://git@gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/ExaMon_Server.git";
    rev = "09048ddd858e802cfc7dcd92b9bb51ba1e07f492";
    narHash = "sha256-vfi/ShFfyiNJ+g7frVV2/iNjtIQWTuevXCPwawTaHMI=";
    allRefs = true;
   };

  #NIX_CFLAGS_COMPILE = "-DDEBUG";
  
  buildInputs = [ openssl_1_0_2 libpfm python3 ];

  preBuild = ''
    # use libpfm from Nixpkgs
    substituteInPlace Makefile --replace "PERFMON = ./lib/perfmon2-libpfm4" ""
    substituteInPlace Makefile --replace "$(PERFMON)" ""
    substituteInPlace publishers/pmu_pub/Makefile --replace ../../lib/perfmon2-libpfm4/lib/libpfm.a ${libpfm}/lib/libpfm.a

    # move configfiles location to /etc/examon/ 
    substituteInPlace publishers/pmu_pub/Makefile --replace '$(INSTALL) -m 644 $(CFGFILE) $(DESTDIR)' ""
    substituteInPlace publishers/pmu_pub/pmu_pub.c --replace '= "pmu_pub.conf";' '= "/etc/examon/pmu_pub.conf";'
    substituteInPlace publishers/pmu_pub/pmu_pub.c --replace '= "host_whitelist";' '= "/etc/examon/host_whitelist";'

    substituteInPlace publishers/pmu_pub/Makefile --replace 'DESTDIR=$(PREFIX)' DESTDIR=$out/bin
  '';

  postInstall = ''
    cp lib/mosquitto-1.3.5/src/mosquitto $out/bin/
    cp lib/mosquitto-1.3.5/src/mosquitto_passwd $out/bin/
    cp lib/mosquitto-1.3.5/client/mosquitto_pub $out/bin/
    cp lib/mosquitto-1.3.5/client/mosquitto_sub $out/bin/

    cp collector/collector-example $out/bin/

    substituteInPlace parser/pmu_pub_sp/pmu_pub_sp.py --replace "config.read('pmu_pub_sp.conf')" "config.read('/etc/examon/pmu_pub_sp.conf')"
    substituteInPlace parser/pmu_pub_sp/mqtt.py --replace sys.path.append '#sys.path.append'
    
    mkdir -p $out/pmu_pub_sp
    cp parser/pmu_pub_sp/*py $out/pmu_pub_sp/
    cp lib/mosquitto-1.3.5/lib/python/mosquitto.py $out/pmu_pub_sp/

    mkdir $out/include
    cp lib/iniparser/src/*.h $out/include/
    cp lib/mosquitto-1.3.5/lib/*.h $out/include/

    mkdir $out/lib
    cp lib/iniparser/libiniparser.a $out/lib/
    cp lib/mosquitto-1.3.5/lib/libmosquitto.a $out/lib/

    mkdir $out/config
    cp lib/mosquitto-1.3.5/mosquitto.conf $out/config/
    cp publishers/pmu_pub/example_pmu_pub.conf $out/config/pmu_pub.conf
    cp publishers/pmu_pub/example_host_whitelist $out/config/host_whitelist
    cp parser/pmu_pub_sp/pmu_pub_sp.conf $out/config/
  '';
  
  meta = with lib; {
    #broken = true;
    homepage = "https://github.com/EEESlab/examon";
    description = "Examon HPC Monitoring: A highly scalable framework for the performance and energy monitoring of HPC servers";
    #license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
