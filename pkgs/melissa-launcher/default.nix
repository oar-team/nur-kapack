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
    ref = "master";
    narHash = "sha256-W2jzCsm0mqkcrMYRUBBaquy9d45FWhxO5C0JOGdw6PA=";
    allRefs = true;
  };

}
