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
    rev = "05b4f0b788d729de3d37fb1a15dacd32028a0dbe";
    sha256 = "sha256-vlRwtMDSPlFCYvj3/YWV0MLP+gIx5FTnWVBu/T8wCW4=";
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
