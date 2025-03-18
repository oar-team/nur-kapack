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
    rev = "12b88f27cf662a94c52a1652b4cc8281b56be6b9";
    sha256 = "sha256-Ehq9EH70Ae/gqXG0tYeOmZxluKenZcHeqkPXXO0tVg0=";
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
