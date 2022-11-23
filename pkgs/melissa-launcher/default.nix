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
    rev = "c97976c77fe9285e3341740ebd8cbeac330ee1ef";
    narHash = "sha256-itTWG4+2hh+3gQ/piE9uVgxGij/51XwcT2QeukiHtKo=";
    allRefs = true;
  };

}
