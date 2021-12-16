{ lib, python3Packages, git, fetchgit }:
# setuptools_scm is a pain: https://github.com/NixOS/nixpkgs/issues/41136
python3Packages.buildPythonPackage rec {
  name = "python-mip";
  version = "1.13.0";
  src = fetchgit {
    url = "https://github.com/coin-or/python-mip";
    rev = "8a6b983df9bbe53a1e06d30689ed9ca278a0d7d8";
    sha256 = "sha256-hIyxkBPibTZhnZUAIVOqv/sjuixAgA6lnqhOztsUD/I";
    leaveDotGit = true;
  };
  nativeBuildInputs = [ git ];
  propagatedBuildInputs = with python3Packages; [ cffi setuptools_scm ];
  doCheck = false;

  meta = with lib; {
    description = "Collection of tools for Mixed-Integer Linear programs";
    homepage = "https://github.com/coin-or/python-mip";
    platforms = platforms.all;
    license = licenses.epl20;
    broken = false;

    longDescription = "Python-MIP: collection of Python tools for the modeling and solution of Mixed-Integer Linear programs";
  };
}
