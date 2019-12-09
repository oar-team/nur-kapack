{ stdenv, pkgs, fetchgit, fetchFromGitHub, python37Packages, zeromq, procset, sqlalchemy_utils, pybatsim,  pytest_flask, remote_pdb}:

python37Packages.buildPythonPackage rec {
  name = "oar-${version}";
  version = "3.0.0.dev3";

  src = /home/auguste/dev/oar3;
  
  #src = fetchgit {
  #  url = /home/auguste/dev/oar3;
  #  sha256 = "17lakcbdfpwi6d8648cb7x6hmm0vylry2336zb901fl04h7d5l75";
  #  rev = "d18cac7666fdea9d07383fca2097dc06c6c079b5";
  #};

  # src = fetchFromGitHub {
  #   owner = "oar-team";
  #   repo = "oar3";
  #   rev = "060d183386e364d3be6a70561f3e85c197537152";
  #   sha256 = "1cq92bbp6s4cbj4l147n1gms206pxnsdsw9zniz4fsbk4cs4fwp1";
  # };

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
    remote_pdb
  ];

  # Tests do not pass
  doCheck = false;

  postInstall = ''
    cp -r setup $out
    cp -r oar/tools $out
    cp -r visualization_interfaces $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/oar-team/oar3";
    description = "The OAR Resources and Tasks Management System";
    license = licenses.lgpl3;
    longDescription = ''
    '';
  };
}
