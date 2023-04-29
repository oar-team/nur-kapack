{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb }:

python3Packages.buildPythonPackage rec {
  pname = "oar";
  version = "3.0.0";
  format = "pyproject";
  
  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
    rev = "402aaeb032b081aa061997a4158951a340becf77";
    sha256 = "sha256-WykQV8JLrIEoGvJVrtTeFAmJwknQZfp9DMDiT9i4drw=";
  };
  
  patches = [
    ./0001-fix-rest-api-resources.patch
    ./0002-location-for-type-in-jobs.patch
    ./0003-events-for-get-jobs.patch
    ./0004-resubmit-job-id.patch
  ];

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
    importlib-metadata
    clustershell
    rich
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
