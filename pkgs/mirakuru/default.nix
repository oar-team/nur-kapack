{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  psutil,
}:

buildPythonPackage rec {
  pname = "mirakuru";
  version = "2.5.2";

  format = "pyproject";
  
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QcpYPTVet6bP3CHBrqVJl51oXCe1cjm4hyVDTxFacTI=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ psutil ];
    
  pythonImportsCheck = [
    "mirakuru"
  ];

  meta = with lib; {
    description = "Process executor (not only) for tests";
    homepage = "https://pypi.org/project/mirakuru";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
