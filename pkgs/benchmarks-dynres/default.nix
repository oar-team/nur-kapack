{ lib
, stdenv
, python3
, fetchFromGitLab
#, dyn_rm-dynres
#, openmpi-dynres
#, dyn_psets
, execo  
, writers
#, pypmix-dynres
, python3Packages

}:

python3Packages.buildPythonApplication rec {
  pname = "benchmarks-dynres";
  version = "0.0.1";
  pyproject = true;
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "benchmarks";
    rev = "2c484e7e3e2e81c184c600e2d3786b8b962c620b";
    hash = "sha256-T/lrzsnP9aYO+FCKbcbQK9NCbfh3rInma8wgXS2DgNs=";
  };
  
  postPatch = ''
    cat <<EOF >> pyproject.toml
    [build-system]
    requires = ["setuptools"]
    build-backend = "setuptools.build_meta"

    [project]
    name = "benchmak-dynres"
    version = "0.0.1"
    dependencies = []

    [tool.setuptools.packages]
    find = {}

    [project.scripts]
    generate_experiments = "experiments.__main__:main"
    run_experiments = "utils.__main__:main"
    EOF
    
    substituteInPlace generate_experiments.py --replace 'if __name__ == "__main__":' "def main():"
    substituteInPlace run_experiments.py --replace 'if __name__ == "__main__":' "def main():"

    mv generate_experiments.py experiments/__main__.py
    mv run_experiments.py utils/__main__.py 
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
    poetry-core
  ];

    propagatedBuildInputs = with python3Packages; [
    #setuptools
    pyyaml
    execo
  ];
  
  meta = with lib; {
    description = "";
    homepage = "https://gitlab.inria.fr/dynres/applications/dynrm_examples";
    license = licenses.bsd3; # FIXME:
    maintainers = with maintainers; [ ];
    mainProgram = "generate_experiments";
  };
}
