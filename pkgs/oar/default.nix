{ lib, pkgs, fetchFromGitHub, python3Packages, poetry, zeromq, procset, pybatsim, remote_pdb  }:

python3Packages.buildPythonPackage rec {
  pname = "oar";
  version = "3.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "oar3";
<<<<<<< HEAD
<<<<<<< HEAD
    rev = "402aaeb032b081aa061997a4158951a340becf77";
    sha256 = "sha256-WykQV8JLrIEoGvJVrtTeFAmJwknQZfp9DMDiT9i4drw=";
=======
    rev = "813efc3cc1082bc1ee2c655dbd07e4d9c96513fd";
    sha256 = "sha256-M1BU3GO4y3JlYNOgXbudtNhYpQ/+hNpcGzzhvAjwLoQ=";
>>>>>>> d3db3ea (fix oar admission rules pb)
=======
    rev = "370f1faecc418233d6dcee2bc278e27247fd63f5";
    sha256 = "sha256-b2cDPa9n7VXGmSC7mQfhTGGNCRurHB8nWwYMSkdLu9A=";
>>>>>>> 8b87042 (new oar3 and posgresql)
  };
  # patches = [ ./0001-bs-loosen-pyzmq-version-constraint.patch ];

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
