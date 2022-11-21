{stdenv, pkgs, fetchFromGitLab, lib, melissa, cmake, gfortran, openmpi, python3 }:

stdenv.mkDerivation rec {
    pname = "heat-pde";
    version = melissa.version;

    # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined/examples/heat-pde/heat-pde;
    # WARNNING: repo below refers to a private repository
  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
    ref = "master";
    narHash = "sha256-W2jzCsm0mqkcrMYRUBBaquy9d45FWhxO5C0JOGdw6PA=";
    allRefs = true;
  };


    buildInputs = [ melissa cmake gfortran openmpi python3 ];
    sourceRoot = "source/examples/heat-pde-sa/heat-pde";

    meta = with lib; {
      homepage = "https://melissa-sa.github.io/";
      description = "Melissa framework example - heat equation";
      platforms = platforms.linux;
      broken = false;
    };
}
