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
    rev = "79ed5f1e677ab210326cb5c1f88befbcb254c8c5";
    sha256 = "sha256-pe1844qXSlkbDxNvhUnhPbJJ9k0mGLEVJJ4Q3irtmJI=";
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
