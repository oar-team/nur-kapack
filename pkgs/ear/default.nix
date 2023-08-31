{ config, pkgs, stdenv, lib, fetchgit, autoreconfHook, which, gsl, postgresql, libmysqlclient, useOar ? true, slurm, useSlurm ? false, openmpi, useExamon ? false,  useMysql ? true, useAvx512 ? false, cudaSupport ? config.cudaSupport or false, cudatoolkit, useGPUS ? true, examon, openssl_1_0_2 }:
# TODO test/finish OAR
# TODO test cudasupport
# TODO test/finish Postgresql
# TODO test/finish Slurm
# TODO test/add debug (test generic approach)
# TODO torque/PBS
# TODO remove workaround for "stack smashing detected"
stdenv.mkDerivation rec {
  pname =  "ear";
  version = "4.3.0b";

  # WARNNING: repo below refers to a private repository
  # src = /home/adfaure/code/ear;
  src = builtins.fetchGit {
     url = "ssh://git@gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/ear.git";
     rev = "478014c053c3f74ba5c1f2a71f744d59f4367881";
     narHash = "sha256-M0RdfT3gcugYQyddCYB4LVooViiSDDzgE6WXZAP7hdk=";
     allRefs = true;
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gsl openmpi which ] ++ [(if useMysql then libmysqlclient else postgresql)] ++ lib.optional cudaSupport cudatoolkit ++ lib.optional useSlurm slurm;

  # preConfigure = (lib.optionalString useMysql ''
  #   mkdir mysql
  #   ln -s ${libmysqlclient.out}/lib mysql
  #   ln -s ${lib.getDev libmysqlclient}/include mysql\n
  # '') + (lib.optionalString useSlurm ''
  #   mkdir slurm
  #   ln -s ${slurm.out}/lib slurm
  #   ln -s ${lib.getDev slurm}/include slurm
  # '');

  preConfigure = ''
  ''+ (if useMysql then ''
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
    "--with-gsl=${gsl.out}"
    ]
    ++ lib.optional useOar "--with-oar"
    ++ lib.optional useSlurm "--with-slurm=slurm"
    ++ [(if useMysql then "--with-mysql=mysql" else "--with-pgsql=${postgresql.out}")]
    ++ (if useAvx512 then ["--enable-avx512"] else ["--disable-avx512"])
    ++ (if cudaSupport then ["--with-cuda=${cudatoolkit.out}"] else [])
    ++ (if useGPUS then ["--enable-gpus"] else []);
  #++ [(if useMysql then "--with-mysql=${libmysqlclient.out}" else "--with-pgsql=${postgresql.out}")]

  preBuild = ''
    substituteInPlace src/report/Makefile --replace 'INC = -I$(EXAMON_BASE)/lib/iniparser/src -I$(EXAMON_BASE)/lib/mosquitto-1.3.5/lib' 'INC = -I${examon}/include'
    substituteInPlace src/report/Makefile --replace 'LDIR = -L/usr/lib -L$(EXAMON_BASE)/lib/iniparser' 'LDIR = -L${examon}/lib'
    substituteInPlace src/report/Makefile --replace 'LIBMOSQ = $(EXAMON_BASE)/lib/mosquitto-1.3.5/lib/libmosquitto.a' 'LIBMOSQ = -lmosquitto'
    # Use option provided by Julita
    substituteInPlace src/library/dynais/Makefile --replace '-march=native' '-msse4.1  -msse4.2 -msse3 -mavx512dq -mavx512f -mavx'
    # But this line also works idk which is best
    # substituteInPlace src/library/dynais/Makefile --replace '-march=native' '-march=native -mcrc32'

    # Meh looks really dirty, because this file is not generated but needed so I create it
    mkdir -p /build/source/src/common/config/
    touch /build/source/src/common/config/defines.log

  '' + (lib.optionalString useExamon "\nexport FEAT_EXAMON=1\n") + (lib.optionalString useMysql ''
    makeFlagsArray=(DB_LDFLAGS="-lmysqlclient -L${libmysqlclient.out}/lib/mysql")
  '');

  # compile ejob
  postBuild = ''
    export SRC=$PWD/src
    cd etc/examples/prolog_epilog
    make SRC=$SRC CC=${stdenv.cc}/bin/gcc CFLAGS=-lm
    cd -
  '';

  postInstall = ''
    cp etc/examples/prolog_epilog/ejob etc/examples/prolog_epilog/oar-ejob $out/bin/
  '';

  meta = with lib; {
    #broken = true;
    homepage = "https://gitlab.bsc.es/ear_team/ear";
    description = "Energy Aware Runtime (EAR) package provides an energy management framework for super computers";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
