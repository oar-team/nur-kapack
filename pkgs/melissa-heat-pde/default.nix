{stdenv, pkgs, fetchFromGitLab, lib, melissa, cmake, gfortran, openmpi, python3 }:

stdenv.mkDerivation rec {
    pname = "heat-pde";
    version = melissa.version;

    # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined/examples/heat-pde/heat-pde;
    # WARNNING: repo below refers to a private repository

    src = builtins.fetchGit {
      url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
      rev = "c2fbcc0e19c773e81e4ba2d3860f37c012902da1";
      narHash = "sha256-OoKOazJb5vyHqMoylECT8BFfqSIpgi+iu0fApRuHWwM=";
      allRefs = true;
    };
    buildInputs = [ melissa cmake gfortran openmpi python3 ];

    # source location differs when src is overrided (source/ vs melissa-combined)
    setSourceRoot = "sourceRoot=$(echo */examples/heat-pde/executables)";

    meta = with lib; {
      homepage = "https://melissa-sa.github.io/";
      description = "Melissa framework example - heat equation";
      platforms = platforms.linux;
      broken = false;
    };
}
