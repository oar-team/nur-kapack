# If called without explicitly setting the 'pkgs' arg, a pinned nixpkgs version is used by default.
# If you want to use your <nixpkgs> instead, set usePinnedPkgs to false (e.g., nix-build --arg usePinnedPkgs false ...)
{ usePinnedPkgs ? true
, pkgs ? if usePinnedPkgs then import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/19.09.tar.gz") {}
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

  libpowercap = pkgs.callPackage ./pkgs/libpowercap { };

  haskellPackages = import ./pkgs/haskellPackages { inherit pkgs; };

  arion = pkgs.callPackage ./pkgs/arion { arion-compose = haskellPackages.arion-compose; };

  batsched-130 = pkgs.callPackage ./pkgs/batsched/batsched130.nix { inherit gmp intervalset loguru redox debug; };
  batsched = batsched-130;
  batsched-master = pkgs.callPackage ./pkgs/batsched/master.nix { inherit gmp intervalset loguru redox debug; };

  batsim-310 = pkgs.callPackage ./pkgs/batsim/batsim310.nix { inherit docopt_cpp intervalset redox debug; simgrid = simgrid-324; };
  batsim = batsim-310;
  batsim-master = pkgs.callPackage ./pkgs/batsim/master.nix { inherit docopt_cpp intervalset redox debug; simgrid = simgrid-light; };

  batsky = pkgs.callPackage ./pkgs/batsky { };

  colmet = pkgs.callPackage ./pkgs/colmet { inherit libpowercap; };

  colmet-rs = pkgs.callPackage ./pkgs/colmet-rs { };

  colmet-collector = pkgs.callPackage ./pkgs/colmet-collector { };

  melissa = pkgs.callPackage ./pkgs/melissa { };

  docopt_cpp = pkgs.callPackage ./pkgs/docopt_cpp { };

  gmp = pkgs.callPackage ./pkgs/gmp { gmp6 = pkgs.gmp6; };

  intervalset = pkgs.callPackage ./pkgs/intervalset { };

  loguru = pkgs.callPackage ./pkgs/loguru { inherit debug; };

  procset = pkgs.callPackage ./pkgs/procset { };

  pybatsim = pkgs.callPackage ./pkgs/pybatsim { inherit procset; };
  pybatsim-master = pkgs.callPackage ./pkgs/pybatsim/master.nix { inherit pybatsim; };

  pytest_flask = pkgs.callPackage ./pkgs/pytest-flask { };

  redox = pkgs.callPackage ./pkgs/redox { };

  remote_pdb = pkgs.callPackage ./pkgs/remote-pdb { };

  cigri = pkgs.callPackage ./pkgs/cigri { };

  oar = pkgs.callPackage ./pkgs/oar { inherit procset sqlalchemy_utils pytest_flask pybatsim remote_pdb; };

  simgrid-324 = pkgs.callPackage ./pkgs/simgrid/simgrid324.nix { inherit debug; };
  simgrid-325 = pkgs.callPackage ./pkgs/simgrid/simgrid325.nix { inherit debug; };
  simgrid-325light = simgrid.override { minimalBindings = true; withoutBin = true; };
  simgrid = simgrid-325;
  simgrid-light = simgrid-325light;

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

