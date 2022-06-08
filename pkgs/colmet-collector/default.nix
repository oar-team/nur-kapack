{ lib, pkgs, fetchFromGitHub, python37Packages }:

python37Packages.buildPythonApplication rec {
  #name = "colmet-collector-${version}";
  name = "colmet-collector";
  version = "0.0.1";

  #src = fetchFromGitHub {
  #  owner = "oar-team";
  #  repo = "colmet-collector";
  #  rev = "a7a5e4460950c4808c1cbd0cf59c8808c52012e6";
  #  sha256 = "1ikqmym68pkmgxwknhmq42bsn5yn0yvpj5wm0wg0q85i9jdlgwwz";
  #};
  
  src = /home/imeignanmasson/colmet-collector;

  propagatedBuildInputs = with python37Packages; [
    pyzmq
    msgpack
    pyyaml
    requests
  ];

  # Tests do not pass
  doCheck = false;

  meta = with lib; {
    description = "Metrics collector for Rust version of Colmet (colmet-rs)";
    homepage    = https://github.com/oar-team/colmet-collector;
    platforms   = platforms.all;
    licence     = licenses.gpl2;
  };
}
