{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "port-for";
  version = "0.7.2";
  
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B08pM1EwV4qkL+83JpheV9AcFRieUJYzqKGwt/kiY0k=";
  };

  nativeBuildInputs = [ setuptools];

  pythonImportsCheck = [
    "port_for"
  ];

  meta = with lib; {
    description = "Utility that helps with local TCP ports management. It can find an unused TCP localhost port and remember the association";
    homepage = "https://pypi.org/project/port-for";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
