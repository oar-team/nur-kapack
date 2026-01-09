{ lib
, stdenv
, fetchFromGitLab
, openmpi-dynres
, autoconf
, automake
}:

stdenv.mkDerivation rec {
  pname = "dyn_psets";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "38020e50734383f4c2df77bbfbcc45918bb4bec1";
    sha256 = "sha256-jYEgsmxJlHHaff/kvBV9kkNRFnR315spnSRAMHWg1WU=";
  };

  nativeBuildInputs = [
    openmpi-dynres
    autoconf
    automake
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Time-X EuroHPC project: dyn_psets";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
