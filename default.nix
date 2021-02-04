# If called without explicitly setting the 'pkgs' arg, a pinned nixpkgs version is used by default.
# If you want to use your <nixpkgs> instead, set usePinnedPkgs to false (e.g., nix-build --arg usePinnedPkgs false ...)
{ usePinnedPkgs ? true
, pkgs ? if usePinnedPkgs then import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz") {}
                          else import <nixpkgs> {}
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
    patches = attrs.patches ++ [ ./pkgs/glibc-batsky/clock_gettime.patch
      ./pkgs/glibc-batsky/gettimeofday.patch ];
    postConfigure = ''
      export NIX_CFLAGS_LINK=
      export NIX_LDFLAGS_BEFORE=
      export NIX_DONT_SET_RPATH=1
      unset CFLAGS
      makeFlagsArray+=("bindir=$bin/bin" "sbindir=$bin/sbin" "rootsbindir=$bin/sbin" "--quiet")
    '';
  });

  go_1_14-batsky = if (pkgs ? go_1_14) then
    (pkgs.go_1_14.overrideAttrs (attrs: {
    src = pkgs.fetchFromGitHub {
      owner = "oar-team";
      repo = "go_1_14-batsky";
      rev = "0119ed47a612226f73a9db56d6572cfab858d59e";
      sha256 = "1795xk5r0h6nl7fgjpdwzhmc4rgyz1v4jr6q46cdzp3fjqg345n3";
    };
    doCheck = false;
  }))
    else
    pkgs.callPackage ({}: {meta.broken=true;}) {};

  libpowercap = pkgs.callPackage ./pkgs/libpowercap { };

  haskellPackages = import ./pkgs/haskellPackages { inherit pkgs; };

  arion = pkgs.callPackage ./pkgs/arion { arion-compose = haskellPackages.arion-compose; };

  batsched-130 = pkgs.callPackage ./pkgs/batsched/batsched130.nix { inherit intervalset loguru redox debug; };
  batsched-140 = pkgs.callPackage ./pkgs/batsched/batsched140.nix { inherit intervalset loguru redox debug; };
  batsched = batsched-140;
  batsched-master = pkgs.callPackage ./pkgs/batsched/master.nix { inherit intervalset loguru redox debug; };

  batexpe = pkgs.callPackage ./pkgs/batexpe { };
  batexpe-master = pkgs.callPackage ./pkgs/batexpe/master.nix { inherit batexpe; };

  batsim-310 = pkgs.callPackage ./pkgs/batsim/batsim310.nix { inherit intervalset redox debug; simgrid = simgrid-324; };
  batsim-400 = pkgs.callPackage ./pkgs/batsim/batsim400.nix { inherit intervalset redox debug; simgrid = simgrid-325light; };
  batsim = batsim-400;
  batsim-master = pkgs.callPackage ./pkgs/batsim/master.nix { inherit intervalset redox debug; simgrid = simgrid-light; };
  batsim-docker = pkgs.callPackage ./pkgs/batsim/batsim-docker.nix { inherit batsim; };
  batsim-docker-master = pkgs.callPackage ./pkgs/batsim/batsim-docker.nix { batsim = batsim-master; };

  batsky = pkgs.callPackage ./pkgs/batsky { };

  cgvg = pkgs.callPackage ./pkgs/cgvg { };

  colmet = pkgs.callPackage ./pkgs/colmet { inherit libpowercap; };

  colmet-rs = pkgs.callPackage ./pkgs/colmet-rs { };

  colmet-collector = pkgs.callPackage ./pkgs/colmet-collector { };

  evalys = pkgs.callPackage ./pkgs/evalys { inherit procset; };

  melissa = pkgs.callPackage ./pkgs/melissa { };

  go-swagger  = pkgs.callPackage ./pkgs/go-swagger { };

  gcovr = pkgs.callPackage ./pkgs/gcovr/csv.nix { };

  intervalset = pkgs.callPackage ./pkgs/intervalset { };

  kube-batch = pkgs.callPackage ./pkgs/kube-batch { };

  loguru = pkgs.callPackage ./pkgs/loguru { inherit debug; };

  procset = pkgs.callPackage ./pkgs/procset { };

  oxidisched = pkgs.callPackage ./pkgs/oxidisched { };

  pybatsim-320 = pkgs.callPackage ./pkgs/pybatsim/pybatsim320.nix { inherit procset; };
  pybatsim = pybatsim-320;
  pybatsim-master = pkgs.callPackage ./pkgs/pybatsim/master.nix { inherit pybatsim; };

  pytest_flask = pkgs.callPackage ./pkgs/pytest-flask { };

  redox = pkgs.callPackage ./pkgs/redox { };

  remote_pdb = pkgs.callPackage ./pkgs/remote-pdb { };

  cigri = pkgs.callPackage ./pkgs/cigri { };

  oar = pkgs.callPackage ./pkgs/oar { inherit procset sqlalchemy_utils pytest_flask pybatsim remote_pdb; };

  rsg-030 = pkgs.callPackage ./pkgs/remote-simgrid/rsg030.nix { inherit debug ; simgrid = simgrid; };
  rsg = rsg-030;
  rsg-master = pkgs.callPackage ./pkgs/remote-simgrid/master.nix { inherit rsg ; };

  simgrid-324 = pkgs.callPackage ./pkgs/simgrid/simgrid324.nix { inherit debug; };
  simgrid-325 = pkgs.callPackage ./pkgs/simgrid/simgrid325.nix { inherit debug; };
  simgrid-326 = pkgs.callPackage ./pkgs/simgrid/simgrid326.nix { inherit debug; };
  simgrid-325light = simgrid-325.override { minimalBindings = true; withoutBin = true; };
  simgrid-326light = simgrid-326.override { minimalBindings = true; withoutBin = true; };
  simgrid = simgrid-326;
  simgrid-light = simgrid-326light;
  simgrid-master = pkgs.callPackage ./pkgs/simgrid/master.nix { inherit simgrid; };
  simgrid-light-master = pkgs.callPackage ./pkgs/simgrid/master.nix { simgrid = simgrid-light; };

  sqlalchemy_utils = pkgs.callPackage ./pkgs/sqlalchemy-utils { };

  # Setting needed for nixos-19.03 and nixos-19.09
  slurm-bsc-simulator =
    if pkgs ? libmysql
    then pkgs.callPackage ./pkgs/slurm-simulator { libmysqlclient = pkgs.libmysql; }
    else pkgs.callPackage ./pkgs/slurm-simulator { };
  slurm-bsc-simulator-v17 = slurm-bsc-simulator;

  #slurm-bsc-simulator-v14 = slurm-bsc-simulator.override { version="14"; };

  slurm-multiple-slurmd = pkgs.slurm.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ ["--enable-multiple-slurmd" "--enable-silent-rules"];});

  slurm-front-end = pkgs.slurm.overrideAttrs (oldAttrs: {
    configureFlags = [
      "--enable-front-end"
      "--with-lz4=${pkgs.lz4.dev}"
      "--with-zlib=${pkgs.zlib}"
      "--sysconfdir=/etc/slurm"
      "--enable-silent-rules"
    ];
  });

  # bs-slurm = pkgs.replaceDependency {
  #   drv = slurm-multiple-slurmd;
  #   oldDependency = pkgs.glibc;
  #   newDependency = glibc-batsky;
  # };

  # fe-slurm = pkgs.replaceDependency {
  #   drv = slurm-front-end;
  #   oldDependency = pkgs.glibc;
  #   newDependency = glibc-batsky;
  # };

  tgz-g5k = pkgs.callPackage ./pkgs/tgz-g5k { };

  wait-for-it = pkgs.callPackage ./pkgs/wait-for-it { };
}

