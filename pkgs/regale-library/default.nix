{ stdenv, lib, cmake, fastdds }:

stdenv.mkDerivation rec {
  pname = "regale-library";
  version = "1.0";

  src = builtins.fetchGit {
     url = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale.git";
     rev = "bccacf984a8a2e40a04c17e37f85af90f3e12e7e";
     narHash = "sha256-2Yylmc5237Ewrzq6Jcyy2x/q9HLZejHwG9dtSIlf3O4=";
     allRefs = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fastdds
  ];

  meta = with lib; {
    description = "Regale published subscribed library.";
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

