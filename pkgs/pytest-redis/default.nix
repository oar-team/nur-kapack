{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mirakuru,
  port-for,
  pytest,
  redis
}:

buildPythonPackage rec {
   pname = "pytest_redis";
   version = "3.1.2";
   
   format = "pyproject";
   
   src = fetchPypi {
     pname = "pytest_redis";
     inherit version;
     hash = "sha256-QcmMAd7xivUzgFwIYrwJje3gO4IopOF3YdrvG+twH98=";
   };
   
   nativeBuildInputs = [ setuptools pytest redis];
   propagatedBuildInputs = [ mirakuru port-for ];
   
   pythonImportsCheck = [
     "pytest_redis"
   ];
   
   meta = with lib; {
     description = "Redis fixtures and fixture factories for Pytest";
     homepage = "https://pypi.org/project/pytest-redis";
     license = licenses.gpl3Only;
     maintainers = with maintainers; [ ];
   };
}
