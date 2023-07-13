# If called without explicitly setting the 'pkgs' arg, a pinned nixpkgs version is used by default.
{ pkgs ? import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/22.05.tar.gz";
      sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
    })
    { }
, pkgs-2111 ? import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/21.11.tar.gz";
      sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
    })
    { }
, debug ? false
}:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays
  inherit pkgs;

  glibc-batsky = pkgs.glibc.overrideAttrs (attrs: {
    meta.broken = true;
    patches = attrs.patches ++ [
      ./pkgs/glibc-batsky/clock_gettime.patch
      ./pkgs/glibc-batsky/gettimeofday.patch
    ];
    postConfigure = ''
      export NIX_CFLAGS_LINK=
      export NIX_LDFLAGS_BEFORE=
      export NIX_DONT_SET_RPATH=1
      unset CFLAGS
      makeFlagsArray+=("bindir=$bin/bin" "sbindir=$bin/sbin" "rootsbindir=$bin/sbin" "--quiet")
    '';
  });

  libpowercap = pkgs.callPackage ./pkgs/libpowercap { };

  haskellPackages = import ./pkgs/haskellPackages { inherit pkgs; };

  batsched-130 = pkgs-2111.callPackage ./pkgs/batsched/batsched130.nix { inherit debug; loguru = loguru-oldnixpkgs; intervalset = intervalsetlight; redox = redox-oldnixpkgs; };
  batsched-140 = pkgs.callPackage ./pkgs/batsched/batsched140.nix { inherit loguru redox debug; intervalset = intervalsetlight; };
  batsched = batsched-140;

  batexpe = pkgs.callPackage ./pkgs/batexpe { };

  batprotocol-cpp = pkgs.callPackage ./pkgs/batprotocol/cpp.nix { inherit flatbuffers debug; };

  batsim-310 = pkgs-2111.callPackage ./pkgs/batsim/batsim310.nix { inherit debug; simgrid = simgrid-324; intervalset = intervalsetlight; redox = redox-oldnixpkgs; };
  batsim-400 = pkgs.callPackage ./pkgs/batsim/batsim400.nix { inherit redox debug; simgrid = simgrid-325light; intervalset = intervalsetlight; };
  batsim-410 = pkgs.callPackage ./pkgs/batsim/batsim410.nix { inherit redox debug; simgrid = simgrid-332light; intervalset = intervalsetlight; };
  batsim = batsim-410;
  batsim-docker = pkgs.callPackage ./pkgs/batsim/batsim-docker.nix { inherit batsim; };

  elastisim = pkgs.callPackage ./pkgs/elastisim { };

  batsky = pkgs.callPackage ./pkgs/batsky { };

  bdpo = pkgs.callPackage ./pkgs/bdpo { };

  bdpo-pmpiwrapper = pkgs.callPackage ./pkgs/bdpo-pmpiwrapper { };

  beo = pkgs.callPackage ./pkgs/beo { };

  cli11 = pkgs.callPackage ./pkgs/cli11 { };

  cgvg = pkgs.callPackage ./pkgs/cgvg { };

  cpp-driver = pkgs.callPackage ./pkgs/cpp-driver {};

  scylladb-cpp-driver = pkgs.callPackage ./pkgs/scylladb-cpp-driver {};

  bacnet-stack = pkgs.callPackage ./pkgs/bacnet-stack { };

  colmet = pkgs.callPackage ./pkgs/colmet { inherit libpowercap; };

  colmet-rs = pkgs.callPackage ./pkgs/colmet-rs { };

  colmet-collector = pkgs.callPackage ./pkgs/colmet-collector { };

  dcdb = pkgs.callPackage ./pkgs/dcdb { inherit scylladb-cpp-driver bacnet-stack mosquitto-dcdb; };

  fastcdr = pkgs.callPackage ./pkgs/fastcdr {};

  ear-examon = pkgs.callPackage ./pkgs/ear { useExamon = true; inherit openssl_1_0_2 examon; };
  ear = pkgs.callPackage ./pkgs/ear { inherit openssl_1_0_2 examon; };
  earCuda = pkgs.callPackage ./pkgs/ear { cudaSupport = true; inherit openssl_1_0_2 examon; };
  earFull= pkgs.callPackage ./pkgs/ear { cudaSupport = true; useExamon = true;
                                         inherit openssl_1_0_2 examon; };

  evalys = pkgs.callPackage ./pkgs/evalys { inherit procset; };

  execo = pkgs.callPackage ./pkgs/execo { };

  #examon-debug = pkgs.enableDebugging examon;

  examon = pkgs.callPackage ./pkgs/examon { inherit openssl_1_0_2; };

  # examon embeds Mosquito v1.5.3 which has openssl < 1.1.0 dependency
  openssl_1_0_2 = pkgs-2111.openssl_1_0_2; # pkgs.callPackage ./pkgs/openssl_1_0_2 { };

  flatbuffers = pkgs.callPackage ./pkgs/flatbuffers/2.0.nix { };

  likwid = pkgs.callPackage ./pkgs/likwid { };

  melissa = pkgs.callPackage ./pkgs/melissa { };
  melissa-launcher = pkgs.callPackage ./pkgs/melissa-launcher { inherit melissa; };
  melissa-heat-pde = pkgs.callPackage ./pkgs/melissa-heat-pde { inherit melissa; };

  python3Packages = rec {
    melissa = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/melissa {};
  };

  melissa-py = pkgs.python3.pkgs.callPackage ./pkgs/python-modules/melissa {};

  npb = pkgs.callPackage ./pkgs/npb { };

  go-swagger = pkgs.callPackage ./pkgs/go-swagger { };

  gocov = pkgs.callPackage ./pkgs/gocov { };

  gocovmerge = pkgs.callPackage ./pkgs/gocovmerge { };

  intervalset = pkgs.callPackage ./pkgs/intervalset { };
  intervalsetlight = pkgs.callPackage ./pkgs/intervalset { withoutBoostPropagation = true; };

  kube-batch = pkgs.callPackage ./pkgs/kube-batch { };

  loguru-oldnixpkgs = pkgs-2111.callPackage ./pkgs/loguru { inherit debug; };
  loguru = pkgs.callPackage ./pkgs/loguru { inherit debug; };

  procset = pkgs.callPackage ./pkgs/procset { };

  mosquitto-dcdb = pkgs.callPackage ./pkgs/mosquitto-dcdb {};

  nxc-cluster = pkgs.callPackage ./pkgs/nxc/cluster.nix { inherit execo; };
  nxc = nxc-cluster;

  oxidisched = pkgs.callPackage ./pkgs/oxidisched { };

  pybatsim-320 = pkgs.callPackage ./pkgs/pybatsim/pybatsim320.nix { inherit procset; };
  pybatsim-321 = pkgs.callPackage ./pkgs/pybatsim/pybatsim321.nix { inherit procset; };
  pybatsim-core-400 = pkgs.callPackage ./pkgs/pybatsim/core400.nix { inherit procset; };
  pybatsim-functional-400 = pkgs.callPackage ./pkgs/pybatsim/functional400.nix { pybatsim-core = pybatsim-core-400; };
  pybatsim = pybatsim-321;
  pybatsim-core = pybatsim-core-400;
  pybatsim-functional = pybatsim-functional-400;

  python-mip = pkgs.callPackage ./pkgs/python-mip { };

  redox-oldnixpkgs = pkgs-2111.callPackage ./pkgs/redox { };
  redox = pkgs.callPackage ./pkgs/redox { };

  remote_pdb = pkgs.callPackage ./pkgs/remote-pdb { };

  rt-tests = pkgs.callPackage ./pkgs/rt-tests { };

  cigri = pkgs.callPackage ./pkgs/cigri { };

  oar = pkgs.callPackage ./pkgs/oar { inherit procset pybatsim remote_pdb; };
  
  oar-plugins = pkgs.callPackage ./pkgs/oar-plugins { inherit procset pybatsim remote_pdb oar; };

  oar2 = pkgs.callPackage ./pkgs/oar2 { };

  oar3 = oar;
  oar3-plugins = oar-plugins;

  rsg-030 = pkgs.callPackage ./pkgs/remote-simgrid/rsg030.nix { inherit debug; simgrid = simgrid-326; };
  rsg = rsg-030;

  # simgrid-3(24->26) compiles with glibc from nixpkgs-21.09 but not with more recent nixpkgs versions
  simgrid-324 = pkgs-2111.callPackage ./pkgs/simgrid/simgrid324.nix { inherit debug; };
  simgrid-325 = pkgs-2111.callPackage ./pkgs/simgrid/simgrid325.nix { inherit debug; };
  simgrid-326 = pkgs-2111.callPackage ./pkgs/simgrid/simgrid326.nix { inherit debug; };
  simgrid-327 = pkgs.callPackage ./pkgs/simgrid/simgrid327.nix { inherit debug; };
  simgrid-328 = pkgs.callPackage ./pkgs/simgrid/simgrid328.nix { inherit debug; };
  simgrid-329 = pkgs.callPackage ./pkgs/simgrid/simgrid329.nix { inherit debug; };
  simgrid-330 = pkgs.callPackage ./pkgs/simgrid/simgrid330.nix { inherit debug; };
  simgrid-331 = pkgs.callPackage ./pkgs/simgrid/simgrid331.nix { inherit debug; };
  simgrid-332 = pkgs.callPackage ./pkgs/simgrid/simgrid332.nix { inherit debug; };
  simgrid-325light = simgrid-325.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-326light = simgrid-326.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-327light = simgrid-327.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-328light = simgrid-328.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-329light = simgrid-329.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-330light = simgrid-330.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid-331light = simgrid-331.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid-332light = simgrid-332.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid = simgrid-332;
  simgrid-light = simgrid-332light;

  # Setting needed for nixos-19.03 and nixos-19.09
  slurm-bsc-simulator =
    if pkgs ? libmysql
    then pkgs.callPackage ./pkgs/slurm-simulator { libmysqlclient = pkgs.libmysql; }
    else pkgs.callPackage ./pkgs/slurm-simulator { };
  slurm-bsc-simulator-v17 = slurm-bsc-simulator;

  #slurm-bsc-simulator-v14 = slurm-bsc-simulator.override { version="14"; };

  slurm-multiple-slurmd = pkgs.slurm.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-multiple-slurmd" "--enable-silent-rules" ];
    meta.platforms = pkgs.lib.lists.intersectLists pkgs.rdma-core.meta.platforms
      pkgs.ghc.meta.platforms;
  });

  slurm-front-end = pkgs.slurm.overrideAttrs (oldAttrs: {
    configureFlags = [
      "--enable-front-end"
      "--with-lz4=${pkgs.lz4.dev}"
      "--with-zlib=${pkgs.zlib}"
      "--sysconfdir=/etc/slurm"
      "--enable-silent-rules"
    ];
    meta.platforms = pkgs.lib.lists.intersectLists pkgs.rdma-core.meta.platforms
      pkgs.ghc.meta.platforms;
  });

  wait-for-it = pkgs.callPackage ./pkgs/wait-for-it { };

  yamldiff = pkgs.callPackage ./pkgs/yamldiff { };
}
