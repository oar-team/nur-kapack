{stdenv, pkgs, fetchFromGitLab, lib, melissa, cmake, gfortran, openmpi, python3 }:

stdenv.mkDerivation rec {
    pname = "heat-pde";
    version = melissa.version;

    # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined/examples/heat-pde/heat-pde;
    # WARNNING: repo below refers to a private repository

    src = builtins.fetchGit {
      url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
      rev = "c97976c77fe9285e3341740ebd8cbeac330ee1ef";
      narHash = "sha256-itTWG4+2hh+3gQ/piE9uVgxGij/51XwcT2QeukiHtKo=";
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
