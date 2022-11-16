{ lib, python3Packages, fetchFromGitLab, melissa }:
with python3Packages;
  buildPythonApplication {

  pname =  "melissa-launcher";
  version = "1.0";
  doCheck = false;

  propagatedBuildInputs = [ melissa pyzmq mpi4py numpy jsonschema ];

  # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined;

  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/adfaure/melissa-combined.git";
    ref = "regale-features";
    narHash = "sha256-s628ifro4qYeW+QhqLNg17QVJafx+3je6/vm4Lp5t4M=";
    allRefs = true;
  };

}
