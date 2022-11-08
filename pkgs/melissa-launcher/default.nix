{ lib, python3Packages, fetchFromGitLab, melissa }:
with python3Packages;
  buildPythonApplication {

  pname =  "melissa-launcher";
  version = "1.0";
  doCheck = false;

  propagatedBuildInputs = [ melissa pyzmq mpi4py numpy jsonschema ];

  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/adfaure/melissa-combined.git";
    ref = "python-packaging";
    narHash = "sha256-Re17+2B6tTioQigjurOvrIY3zVGh9Z7HQ/yrbHPpxuA=";
    allRefs = true;
  };

}
