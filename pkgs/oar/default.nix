{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb }:

python3Packages.buildPythonPackage rec {
  name = "oar-${version}";
  version = "3.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
    rev = "3460b794d918121aa70198abf9fdd7ac21fcd23d";
    sha256 = "sha256-9lV6i3WjLBPV2nuoB0qRlf8dg4K8+djlfX1a4MMFcY8=";
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
