{ lib
, python3
, fetchFromGitLab
, pmix
, openmpi-dynres
, dyn_psets
, pypmix
, pyscipopt
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
    rev = "3d00096989f9a610e84f2bd5919ba8c380c6775f";
    hash = "sha256-HqyVGZT3nAsE7XTV+Kb5TRVE3fwZIHtnTKQwetkwGxE=";
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
    pyscipopt
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
