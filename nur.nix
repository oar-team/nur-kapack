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

  batsched-140 = pkgs.callPackage ./pkgs/batsched/batsched140.nix { inherit loguru redox debug; intervalset = intervalsetlight; };
  batsched = batsched-140;

  batexpe = pkgs.callPackage ./pkgs/batexpe { };

  batsim-410 = pkgs.callPackage ./pkgs/batsim/batsim410.nix { inherit redox debug; simgrid = simgrid-334light; intervalset = intervalsetlight; };
  batsim-420 = pkgs.callPackage ./pkgs/batsim/batsim420.nix { inherit redox debug; simgrid = simgrid-334light; intervalset = intervalsetlight; };
  batsim = batsim-420;
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

  #alumet = pkgs.callPackage ./pkgs/alumet { };
  
  colmet = pkgs.callPackage ./pkgs/colmet { inherit libpowercap; };

  colmet-rs = pkgs.callPackage ./pkgs/colmet-rs { };

  colmet-collector = pkgs.callPackage ./pkgs/colmet-collector { };

  dcdb = pkgs.callPackage ./pkgs/dcdb { inherit scylladb-cpp-driver bacnet-stack mosquitto-dcdb; };

  distem = pkgs.callPackage ./pkgs/distem { };


  ear-examon = pkgs.callPackage ./pkgs/ear { useExamon = true; inherit openssl_1_0_2 examon; };
  ear = pkgs.callPackage ./pkgs/ear { inherit openssl_1_0_2 examon; };
  earCuda = pkgs.callPackage ./pkgs/ear { cudaSupport = true; inherit openssl_1_0_2 examon; };
  earFull= pkgs.callPackage ./pkgs/ear { cudaSupport = true; useExamon = true;
                                         inherit openssl_1_0_2 examon; };
  
  enoslib = pkgs.callPackage ./pkgs/enoslib { inherit execo iotlabsshcli distem python-grid5000; };

  evalys = pkgs.callPackage ./pkgs/evalys { inherit procset; };

  execo = pkgs.callPackage ./pkgs/execo { };

  flower = pkgs.callPackage ./pkgs/flower { inherit iterators; };

  iotlabcli = pkgs.callPackage ./pkgs/iotlabcli { };
  iotlabsshcli = pkgs.callPackage ./pkgs/iotlabsshcli { inherit iotlabcli parallel-ssh; };

  #examon-debug = pkgs.enableDebugging examon;

  examon = pkgs.callPackage ./pkgs/examon { inherit openssl_1_0_2; };

  # examon embeds Mosquito v1.5.3 which has openssl < 1.1.0 dependency
  openssl_1_0_2 = pkgs-2111.openssl_1_0_2; # pkgs.callPackage ./pkgs/openssl_1_0_2 { };

  #flatbuffers = pkgs.callPackage ./pkgs/flatbuffers/2.0.nix { };

  likwid = pkgs.callPackage ./pkgs/likwid { };

  melissa = pkgs.callPackage ./pkgs/melissa { };
  melissa-launcher = pkgs.callPackage ./pkgs/melissa-launcher { inherit melissa; };
  melissa-heat-pde = pkgs.callPackage ./pkgs/melissa-heat-pde { inherit melissa; };

  #
  #Time-X EuroHPC project: dynres (mpi and dynamicity)
  #
  pmix-dynres = pkgs.callPackage ./pkgs/pmix-dynres { inherit oac; };
  pypmix-dynres = pkgs.python3.pkgs.toPythonModule pmix-dynres;
  prrte-dynres = pkgs.callPackage ./pkgs/prrte-dynres { pmix = pmix-dynres; inherit oac; };
  prrte-expansion-test = import ./pkgs/prrte_expansion_test { inherit dyn_rm-dynres pypmix-dynres; writers=pkgs.writers; lib=pkgs.lib; };
  openmpi-dynres = pkgs.callPackage ./pkgs/openmpi-dynres { fortranSupport = true; pmix = pmix-dynres; prrte = prrte-dynres; ucc = ucc_1_3; ucx = ucx_1_17;  inherit oac; };
  miniapps-dynres = pkgs.callPackage ./pkgs/miniapps-dynres { inherit openmpi-dynres; };
  dyn_rm-dynres = pkgs.callPackage ./pkgs/dyn_rm-dynres { pmix = pmix-dynres; pypmix = pypmix-dynres; inherit openmpi-dynres dyn_psets; };
  dyn_psets = pkgs.callPackage ./pkgs/dyn_psets { inherit openmpi-dynres; };
  dyn_rm-examples-dynres = pkgs.callPackage ./pkgs/dyn_rm-examples-dynres { inherit dyn_rm-dynres openmpi-dynres dyn_psets pypmix-dynres; };
  oac =  pkgs.callPackage ./pkgs/oac { };
  ucc_1_3 = pkgs.callPackage ./pkgs/ucc { ucx = ucx_1_17; };
  ucx_1_17 = pkgs.callPackage ./pkgs/ucx { };
  dmr = pkgs.callPackage ./pkgs/dmr { openmpi = openmpi-dynres; };
  dmr-examples = pkgs.callPackage ./pkgs/dmr_examples { openmpi = openmpi-dynres; inherit dmr timestamps data_redist dyn_rm-dynres pypmix-dynres; };
  timestamps = pkgs.callPackage ./pkgs/timestamps { };
  data_redist = pkgs.callPackage ./pkgs/data_redist { openmpi = openmpi-dynres; };
  p4est-sc-dynres = pkgs.p4est-sc.override { mpi=openmpi-dynres; };
  p4est-dynres = pkgs.p4est.override { p4est-sc=p4est-sc-dynres; };
  p4est-dyn = pkgs.callPackage ./pkgs/p4est_dyn {inherit openmpi-dynres p4est-dynres; };
  p4est-dyn-examples = pkgs.callPackage ./pkgs/p4est_dyn_examples {inherit openmpi-dynres p4est-dynres p4est-dyn timestamps dyn_rm-dynres pypmix-dynres; };
  dynpetsc = pkgs.callPackage ./pkgs/dynpetsc {inherit openmpi-dynres sowing; }; 
  sowing = pkgs.callPackage ./pkgs/sowing { };
  dynpetsc-examples = pkgs.callPackage ./pkgs/dynpetsc_examples {inherit openmpi-dynres dynpetsc timestamps dyn_rm-dynres pypmix-dynres; };
  xbraid = pkgs.callPackage ./pkgs/xbraid { inherit openmpi-dynres; };
  dyn-xbraid =  pkgs.callPackage ./pkgs/dyn_xbraid { inherit openmpi-dynres xbraid dmr; };
  dyn-xbraid-examples = pkgs.callPackage ./pkgs/dyn_xbraid_examples { inherit openmpi-dynres xbraid dyn-xbraid dmr timestamps dyn_rm-dynres pypmix-dynres; };
  benchmarks-dynres =  pkgs.callPackage ./pkgs/benchmarks-dynres {inherit execo; };

  
  ####################

  
  dynrm-oar = pkgs.callPackage ./pkgs/dynrm-oar { dyn_rm = dyn_rm-dynres; };
  
  pytest-redis = pkgs.python3.pkgs.callPackage ./pkgs/pytest-redis { inherit mirakuru port-for; };
  mirakuru = pkgs.python3.pkgs.callPackage ./pkgs/mirakuru { };
  port-for = pkgs.python3.pkgs.callPackage ./pkgs/port-for { };
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

  iterators = pkgs.callPackage ./pkgs/iterators { };

  kube-batch = pkgs.callPackage ./pkgs/kube-batch { };

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

  redox = pkgs.callPackage ./pkgs/redox { };

  remote_pdb = pkgs.callPackage ./pkgs/remote-pdb { };

  rt-tests = pkgs.callPackage ./pkgs/rt-tests { };

  cigri = pkgs.callPackage ./pkgs/cigri { };

  oar = pkgs.callPackage ./pkgs/oar { inherit procset pybatsim remote_pdb oar-plugins; };
  
  oar-plugins = pkgs.callPackage ./pkgs/oar-plugins { inherit procset pybatsim remote_pdb oar; };

  oar2 = pkgs.callPackage ./pkgs/oar2 { };

  oar3 = oar;
  oar3-plugins = oar-plugins;

  #oar-with-plugins = oar.override { enablePlugins = true; };
  oar-with-plugins = pkgs.callPackage ./pkgs/oar { inherit procset pybatsim remote_pdb oar-plugins; enablePlugins = true; };
    
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
  simgrid-334 = pkgs.callPackage ./pkgs/simgrid/simgrid334.nix { inherit debug; };
  simgrid-327light = simgrid-327.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-328light = simgrid-328.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-329light = simgrid-329.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; };
  simgrid-330light = simgrid-330.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid-331light = simgrid-331.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid-332light = simgrid-332.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid-334light = simgrid-334.override { minimalBindings = true; withoutBin = true; withoutBoostPropagation = true; buildPythonBindings = false; };
  simgrid = simgrid-334;
  simgrid-light = simgrid-334light;

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

  ssh-python = pkgs.callPackage ./pkgs/ssh-python { };
  ssh2-python = pkgs.callPackage ./pkgs/ssh2-python { };

  parallel-ssh = pkgs.callPackage ./pkgs/parallel-ssh { inherit ssh-python ssh2-python; };

  python-grid5000 = pkgs.callPackage ./pkgs/python-grid5000 { };

  starpu = pkgs.callPackage ./pkgs/starpu { };

  wait-for-it = pkgs.callPackage ./pkgs/wait-for-it { };

  wirerope = pkgs.callPackage ./pkgs/wirerope { };

  yamldiff = pkgs.callPackage ./pkgs/yamldiff { };
}
