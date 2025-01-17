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
    rev = "23af17b1b217df04f79c8d9af13bd119f353e504";
    sha256 = "sha256-A2idn9uKyvfdTtQXFyjePItA+cdsM5e5+C5YUErUE6E=";
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
