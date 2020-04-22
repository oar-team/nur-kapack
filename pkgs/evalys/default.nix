{stdenv, python3Packages, procset}:
python3Packages.buildPythonPackage rec {
  pname = "evalys";
  version = "4.0.4";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1j9gp1zdfaip0kfyf64n1aa9ayllfb85xlbn0srmr4a2gb3r4jq7";
  };

  propagatedBuildInputs = with python3Packages; [
    procset
    seaborn
    pandas
    pyqt5
    ipywidgets
    matplotlib
  ];

  # FIXME: tests are not passing and need to be refactored...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Infrastructure Performance Evaluation Toolkit Edit";
    homepage    = https://github.com/oar-team/evalys;
    platforms   = platforms.unix;
    license = licenses.bsd3;
    longDescription = ''
        Evalys is a data analytics library made to load, compute,
        and plot data from job scheduling and resource management traces.
        It allows scientists and engineers to extract useful data and
        visualize it interactively or in an exported file.
    '';
    broken = false;
  };
}
