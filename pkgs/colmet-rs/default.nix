{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, zeromq, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "colmet-rs";
  version = "0.0.1";

  # src = fetchFromGitHub {
  #   owner = "";
  #   repo = pname;
  #   rev = "";
  #   sha256 = "";
  # };

  src = /home/auguste/dev/colmet-rs;
  
  buildInputs = [ zeromq cmake ];
  nativeBuildInputs = [ pkgconfig ];

  #LD_LIBRARY_PATH="${lib_perf_hw}/lib"; 
  
  cargoSha256 = "1yr0wbq6qdphmzj3jbili3isgwc0xkd06gkx0xvpinhkp6k5y7n3";

  meta = with stdenv.lib; {
    homepage = https://github.com/oar-team;
    description = "Monitoring processes inside cgroup";
    license = licenses.lgpl2;
    
  };
}
