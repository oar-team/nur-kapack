# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  glibc-batsky = pkgs.glibc.overrideAttrs (attrs: {
    patches = attrs.patches ++ [ ./pkgs/glibc-batsky/clock_gettime.patch
      ./pkgs/glibc-batsky/gettimeofday.patch ];
  });

  
  
  batsky = pkgs.callPackage ./pkgs/batsky { };

  procset = pkgs.callPackage ./pkgs/procset { };
  
  pybatsim = pkgs.callPackage ./pkgs/pybatsim { inherit procset; };

  pytest_flask = pkgs.callPackage ./pkgs/pytest-flask { };

  remote_pdb = pkgs.callPackage ./pkgs/remote-pdb { };
  
  oar = pkgs.callPackage ./pkgs/oar { inherit procset sqlalchemy_utils pytest_flask pybatsim remote_pdb; };

  sqlalchemy_utils = pkgs.callPackage ./pkgs/sqlalchemy-utils { };
  
  
  slurm-bsc-simulator =  pkgs.callPackage ./pkgs/slurm-simulator { libmysqlclient = pkgs.libmysql; };

  slurm-bsc-simulator-v17 = slurm-bsc-simulator;
  
  slurm-bsc-simulator-v14 = slurm-bsc-simulator.override { version="14"; };
  
  slurm-multiple-slurmd = pkgs.slurm.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ ["--enable-multiple-slurmd"];});
  
  slurm-front-end = pkgs.slurm.overrideAttrs (oldAttrs: {
    #configureFlags = with pkgs.stdenv.lib; [
    configureFlags = [
      "--enable-front-end"
      "--with-lz4=${pkgs.lz4.dev}"
      "--with-zlib=${pkgs.zlib}"
      "--sysconfdir=/etc/slurm"
    ];
    version = "19.05.3.2";
    src = pkgs.fetchFromGitHub {
      owner = "SchedMD";
      repo = "slurm";
      rev = "19-05-3-2";
      sha256 = "1ds4dvwswyx9rjcmcwz2fm2zi3q4gcc2n0fxxihl31i5i6wg1kv0";
    };
  });

  bs-slurm = pkgs.replaceDependency {
    drv = slurm-multiple-slurmd;
    oldDependency = pkgs.glibc;
    newDependency = glibc-batsky;
  };
  
  fe-slurm = pkgs.replaceDependency {
    drv = slurm-front-end;
    oldDependency = pkgs.glibc;
    newDependency = glibc-batsky;
  };
  
}

