{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb  }:

python3Packages.buildPythonPackage rec {
  pname = "oar";
  version = "3.0.0.dev11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
    rev = "1a8bcf9c90c87d444de22a5fa3fbdfbdecc678f0"; 
    sha256 = "sha256-XQas3karmxJPGXkU3qnQAZ3jxI+8qXHwR78zMohKTvQ=";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = with python3Packages; [
    poetry-core
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
    clustershell
    rich
    httpx
    python-jose
    passlib
    bcrypt
  ];

  doCheck = false;
  postInstall = ''
    cp -r setup $out
    cp -r oar/tools $out
    cp -r visualization_interfaces $out

    mkdir -p $out/admission_rules.d
    cp -r etc/oar/admission_rules.d/0*.py $out/admission_rules.d
  '';

  meta = {
    broken = false;
    homepage = "https://github.com/oar-team/oar3";
    description = "OAR: a Versatile Resource and Job Manager";
    license = lib.licenses.lgpl21;
    longDescription = "";
  };
}
