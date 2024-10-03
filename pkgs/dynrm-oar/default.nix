{ lib
, python3
, fetchFromGitLab
, dyn_rm
, poetry  
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dynrm-oar";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "OAR";
    #group = "";
    repo = "dynrm-oar";
    rev = "e325e7ba79c6dfb7d25aa7bff90892f71087e68f";
    hash = "sha256-abtg68+khxywOBdweEA2q18pjihCZGYuy2RmKwSQfoQ=";
  };

  nativeBuildInputs = [
    poetry
    python3.pkgs.poetry-core
    #python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.click
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
