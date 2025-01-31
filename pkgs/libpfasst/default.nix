{ stdenv
, lib
, fetchFromGitLab
, timestamps
, hypre
, openmpi-dynres  
}:
stdenv.mkDerivation rec {
  pname = "libpfasst";
  version = "0.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "6212fec544c48bbc984d191eb74aa6a63fa8108d";
    sha256 = "sha256-0lNnMLX6QylWMnx1Q7MJwAEUNseXrMZURDK1ROW2DRE=";
  };
  
 
  nativeBuildInputs = [ timestamps hypre openmpi-dynres ];

  buildPhase = "make -j TIMESTAMPS=${timestamps}";

  installPhase = ''
    mkdir -p $out/lib
	  mkdir -p $out/include
	  cp lib/libpfasst.a $out/lib
    cp include/* $out/include
  '';

  meta = with lib; {
    description = "(Modified) LibPFASST is a lightweight implementation of the Parallel Full Approximation Scheme in Space and Time (PFASST) algorithm";
    homepage = "https://libpfasst.github.io/LibPFASST";
    license = licenses.lgpl21;
    maintainers = [ ]; # Olivier Richard
    platforms = platforms.linux;
  };
}
