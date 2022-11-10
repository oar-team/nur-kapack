{stdenv, pkgs, fetchFromGitLab, lib, melissa, cmake, gfortran, openmpi, python3 }:

stdenv.mkDerivation rec {
    pname = "heat-pde";
    version = melissa.version;

    # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined/examples/heat-pde/heat-pde;
    # WARNNING: repo below refers to a private repository
    src = builtins.fetchGit {
       url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
       rev = "5f1757d966e8c09b874102f9f1479a432d67b633";
       narHash = "sha256-oE4uKQZcl/0o0VmoInmdqABvxP3k4OZENNgZBpRS728=";
       allRefs = true;
    };

    buildInputs = [ melissa cmake gfortran openmpi python3 pkgs.tree ];
    sourceRoot = "source/examples/heat-pde-sa/heat-pde";

    meta = with lib; {
      homepage = "https://melissa-sa.github.io/";
      description = "Melissa framework example - heat equation";
      platforms = platforms.linux;
      broken = false;
    };
}
