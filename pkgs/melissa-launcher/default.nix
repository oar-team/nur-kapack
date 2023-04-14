{ lib, python3Packages, fetchFromGitLab, melissa }:
with python3Packages;
  buildPythonApplication {

  pname =  "melissa-launcher";
  version = "1.0";
  doCheck = false;

  propagatedBuildInputs = [ melissa pyzmq mpi4py numpy jsonschema python-rapidjson requests plotext ];

  # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined;

  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/adfaure/melissa.git";
    rev = "c3892f459b11680bcbd25fa69760a3af7f5bc131";
    narHash = "sha256-1cU/xkEzlj3TUGxwUlvbWDPhAU2sGbtLEKTaPF4bAuk=";
    allRefs = true;
  };

}
