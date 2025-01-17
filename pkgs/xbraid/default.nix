{ stdenv
, lib
, fetchFromGitHub
, openmpi-dynres
} :

stdenv.mkDerivation rec {
  pname = "xbraid";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "XBraid";
    repo = pname;
    rev = "4bbd644a9180f923959147038ab6c07b9490a2be";
    sha256 = "sha256-bAHARTNwM+ynENziatb8bo9deTk1KZledLDAEvkHrBY=";
  };
  #rev = "v${version}";
  #sha256 = "sha256-u7XVSiEZsmzQf4zvQCTbBtm4UQanLGo3odLZsNcLWr4=";
 
  nativeBuildInputs = [ openmpi-dynres ];

  buildPhase = "make braid";

  installPhase = ''
    mkdir -p $out/lib
	  mkdir -p $out/include
	  cp braid/libbraid.a $out/lib
    cp braid/*.h $out/include
  '';

  meta = with lib; {
    description = "XBraid Parallel-in-Time Solvers ";
    homepage = "https://github.com/XBraid/xbraid";
    license = licenses.lgpl21;
    maintainers = [ ]; # Olivier Richard
    platforms = platforms.linux;
  };
}
