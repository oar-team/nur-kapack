{ lib
, python3
, fetchFromGitLab
, pmix
, openmpi-dynres
, dyn_psets
, pypmix
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dyn-rm";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "dyn_rm";
    rev = "1413e5e709f3d2e23edd9d6eb6d334e8afde005e";
    hash = "sha256-L1hqAsbPY4RIPZzjWgiZPuaWS1/DXzUx+yAboAfdRg4=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    openmpi-dynres
    dyn_psets
    pypmix
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pyyaml
    python3.pkgs.requests
    python3.pkgs.pyomo
    python3.pkgs.scipy
    pmix
    dyn_psets
    pypmix
  ];

  doCheck = false;

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/dyn-procs/dyn_rm";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
