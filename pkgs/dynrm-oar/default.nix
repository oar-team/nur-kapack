{ lib
, python3
, fetchFromGitLab
, dyn_rm
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dynrm-oar";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "OAR";
    #owner = "";
    repo = "dynrm_oar";
    rev = "cbb5e224554aac98d04d26e4c3ad047787cdf85a";
    hash = "sha256-Vu1gAIlY2IFqIoxxnY1b/ZScyDn6TscllVWXXqMxagM=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    dyn_rm
  ];

  doCheck = false;

  preBuild = ''
  '';

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/OAR/dynrm-oar";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dynrm-oar";
  };
}
