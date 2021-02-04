{ stdenv, pkgs, fetchgit, fetchFromGitHub, python37Packages, zeromq, procset, sqlalchemy_utils, pybatsim,  pytest_flask, remote_pdb}:

python37Packages.buildPythonPackage rec {
  name = "oar-${version}";
  version = "3.0.0.dev4";  

  src = fetchFromGitHub {
      owner = "oar-team";
      repo = "oar3";
      rev = "88d7a903df7ece3a0e9bcb0b8979917b838c4ab8";
      sha256 = "1kj1rlqmk1l9k5gdaa1i4wa3gpqy9bs1d644h3gf469s74vq0d44";
  };
  #src = /home/auguste/dev/oar3;

  propagatedBuildInputs = with python37Packages; [
    pyzmq
    requests
    sqlalchemy
    alembic
    procset
    click
    simplejson
    flask
    tabulate
    psutil
    sqlalchemy_utils
    simpy
    redis
    pybatsim
    pytest_flask
    psycopg2
    remote_pdb # for debug only
    passlib
    pyyaml
    escapism
    toml
  ];

  # Tests do not pass
  doCheck = false;

  postInstall = ''
    cp -r setup $out
    cp -r oar/tools $out
    cp -r visualization_interfaces $out
  '';

  meta = with stdenv.lib; {
    broken = true;
    homepage = "https://github.com/oar-team/oar3";
    description = "The OAR Resources and Tasks Management System";
    license = licenses.lgpl3;
    longDescription = ''
    '';
  };
}
