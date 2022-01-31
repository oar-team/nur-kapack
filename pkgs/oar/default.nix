{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb }:

python3Packages.buildPythonPackage rec {
  name = "oar-${version}";
  version = "3.0.0.dev4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
    rev = "6fa679652f200cbebad709f9ffd7d4e15e8ecf45";
    sha256 = "sha256-nbdymJxTHSRcpx6KNCPDt4K/VeYa5GrC+7gGw8lSljc=";
  };

  nativeBuildInputs = [ poetry ];

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
  ];

  doCheck = false;
  #doCheck = true;
  postInstall = ''
    cp -r setup $out
    cp -r oar/tools $out
    cp -r visualization_interfaces $out
  '';

  meta = {
    #broken = true;
    homepage = "https://github.com/oar-team/oar3";
    description = "The OAR Resources and Tasks Management System";
    license = lib.licenses.lgpl3;
    longDescription = "";
  };
}
