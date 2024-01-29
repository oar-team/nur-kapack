# If called without explicitly setting the 'pkgs' arg, a pinned nixpkgs version is used by default.
{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz";
    sha256 = "sha256:1ndiv385w1qyb3b18vw13991fzb9wg4cl21wglk89grsfsnra41k";
  }) {}
, debug ? false
}:

let
  nur-pkgs = import ./nur.nix { inherit pkgs debug; };
  master-pkgs = rec {
    batsched-master = pkgs.callPackage ./pkgs/batsched/master.nix { inherit debug; intervalset = nur-pkgs.intervalsetlight; loguru = nur-pkgs.loguru; redox = nur-pkgs.redox; };

    batexpe-master = pkgs.callPackage ./pkgs/batexpe/master.nix { batexpe = nur-pkgs.batexpe; };

    batsim-master = pkgs.callPackage ./pkgs/batsim/master.nix { inherit debug; intervalset = nur-pkgs.intervalsetlight; redox = nur-pkgs.redox; simgrid = nur-pkgs.simgrid-light; };
    batsim-docker-master = pkgs.callPackage ./pkgs/batsim/batsim-docker.nix { batsim = batsim-master; };

    pybatsim-master = pkgs.callPackage ./pkgs/pybatsim/master.nix { pybatsim = nur-pkgs.pybatsim; };

    simgrid-master = pkgs.callPackage ./pkgs/simgrid/master.nix { simgrid = nur-pkgs.simgrid; };
    simgrid-light-master = pkgs.callPackage ./pkgs/simgrid/master.nix { simgrid = nur-pkgs.simgrid-light; };
  };
in
  nur-pkgs // master-pkgs
