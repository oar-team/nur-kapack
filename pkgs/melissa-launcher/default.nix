{ lib, python3Packages, fetchFromGitLab, melissa }:
with python3Packages;
  buildPythonApplication {

  pname =  "melissa-launcher";
  version = "1.0";
  doCheck = false;

  propagatedBuildInputs = [ melissa pyzmq mpi4py numpy jsonschema ];

  # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined;

  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
    rev = "c2fbcc0e19c773e81e4ba2d3860f37c012902da1";
    narHash = "sha256-OoKOazJb5vyHqMoylECT8BFfqSIpgi+iu0fApRuHWwM=";
    allRefs = true;
  };

}
