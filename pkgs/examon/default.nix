{ config, stdenv, lib, fetchgit, openssl_1_0_2, libpfm, python3}:
stdenv.mkDerivation rec {
  pname =  "examon";
  version = "0.2.3";

  # WARNNING: repo below refers to a private repository
  src = builtins.fetchGit {
   url = "ssh://git@gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/ExaMon_Server.git";
   rev = "a1cc128fc0a5e03fee7582d816e046478bdd9457";
   narHash = "sha256-dI8d8qBQjOGNndGCOTGtrf19A9FmO0GBPYT8cnA05BI=";
  };

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
    mkdir $out/include
    cp lib/iniparser/src/*.h $out/include/
    cp lib/mosquitto-1.3.5/lib/*.h $out/include/

    mkdir $out/lib
    cp lib/iniparser/libiniparser.a $out/lib/
    cp lib/mosquitto-1.3.5/lib/libmosquitto.a $out/lib/
  '';
  
  meta = with lib; {
    #broken = true;
    homepage = "https://github.com/EEESlab/examon";
    description = "Examon HPC Monitoring: A highly scalable framework for the performance and energy monitoring of HPC servers";
    #license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
