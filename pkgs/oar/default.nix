{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb, oar-plugins, enablePlugins ? false}:

python3Packages.buildPythonPackage rec {
  pname = "oar";
  version = "3.0.0";
  format = "pyproject";
  
  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
    rev = "1872491fafdaeafc6a4fcec0e31cc0b545a80d28";
    sha256 = "sha256-fQXJsqmAUOWiojp2gjC9HieJ3nOMzjKfmy9G0Lwmh20=";
  };

  nativeBuildInputs = [
    poetry
    python3Packages.poetry-core
  ];

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
  ] ++ lib.optional enablePlugins oar-plugins;

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
