{ lib
, python3
, fetchFromGitLab
, pmix  
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dyn-rm";
  version = "unstable-2023-09-28";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "dyn_rm";
    rev = "4a02eb86f28f6e67986190e5e8292a123bcdaf64";
    hash = "sha256-wnFuLVvlIcCA/CCoG+pcQCwiNEW8HxnP+ILDZ+rXJFw=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];
  
  propagatedBuildInputs = [
    pmix
  ];
  
  doCheck = false;
  
  postInstall = ''
      for f in examples/*; do
        substituteInPlace $f  --replace "-x LD_LIBRARY_PATH -x DYNMPI_BASE /opt/hpc/build/test_applications/build/" " "
      done
      cp -a examples $out
  '';
  
  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/dyn-procs/dyn_rm";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "dyn-rm";
  };
}
