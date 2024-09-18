{ lib, stdenv, fetchFromGitLab, openmpi-dynres, autoconf, automake
} :

stdenv.mkDerivation rec {
  pname = "dyn_psets";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "90dc85c6da1e68e97ba953403779130e36b68cb1";
    sha256 = "sha256-01hB8TKbwRzWMp3znldgF8qheiPZQPmyLkm9Taj6Ozg=";
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
