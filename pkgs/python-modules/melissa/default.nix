{ buildPythonPackage
, pkgs
, python3
}:

buildPythonPackage rec {
  pname = "melissa";
  version = "0.7.1";
  
  src = /home/auguste/dev/melissa-combined;
  
  doCheck = false;

  #pythonImportsCheck = [  ];

  meta = with pkgs.lib; {
    homepage = "https://melissa-sa.github.io/";
    description = "Melissa is a file avoiding, adaptive, fault tolerant and elastic framework, to run large scale sensitivity analysis on supercomputers";
    license = licenses.bsd3;
    broken = false;
  };

}
