{ lib, fetchgit, fetchFromGitHub, python3Packages, pkgs, zeromq }:

python3Packages.buildPythonApplication rec {
  pname = "batsky";
  version = "0.1.0";
  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  src = fetchFromGitHub {
    owner = "oar-team";
    repo = "batsky";
    rev = "3e9f14a4bdaac56d934c31f888858ac7a9f645c8";
    sha256 = "0s1bvbi65gc5304zh9yv4jr60jvgb5g0wx6p2fm5vn28lplvcdkf";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    pyinotify
    pyzmq
    clustershell
    sortedcontainers
  ];

  # Tests do not pass
  doCheck = false;

  meta = with lib; {
    description = "";
    homepage    = https://github.com/oar-team/batsky;
    platforms   = python3Packages.pyinotify.meta.platforms;
    licence     = licenses.gpl2;
    longDescription = ''
    '';
  };
}
