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
    rev = "f0af3d8acf0406feb9e1e670fdd1ca118f9f9b4a";
    hash = "sha256-/i938FQqSOiHzC9/zrzc9Xr4soTfZp7D+MfeHmKWBKI=";
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
