{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb, oar }:

python3Packages.buildPythonPackage rec {
  pname = "oar3-plugins";
  version = "0.0.0a";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3-plugins";
    rev = "main";
    sha256 = "sha256-y42XXvoMIg2BNUm3e/RZ8+eR7ntSclW2DIzdkU5zS9M=";
  };

  nativeBuildInputs = [ poetry ];

  buildInputs = with python3Packages; [ oar ];

  propagatedBuildInputs = with python3Packages; [
    pyzmq
    requests
    alembic
    procset
    click
    simplejson
    flask
    tabulate
    psutil
    sqlalchemy-utils
    psycopg2
    passlib
    escapism
    toml
    fastapi
    uvicorn
    pyyaml
    ptpython
    python-multipart
    importlib-metadata
  ];

  doCheck = false;

  meta = {
    broken = false;
    homepage = "https://github.com/oar-team/oar3";
    description = "Official plugin repository for oar";
    license = lib.licenses.lgpl21;
    longDescription = "";
  };
}
