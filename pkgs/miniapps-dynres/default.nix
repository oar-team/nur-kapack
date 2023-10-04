{ lib, stdenv, fetchFromGitLab, scons, openmpi-dynres
} :

stdenv.mkDerivation rec {
  pname = "miniapps";
  version = "0.0.0";
  
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = pname;
    rev = "ec96341aae5b30b9e4348972f46a8478443fc8b7";
    sha256 = "sha256-7HgSDaGfWSdJtaKlCHweiW1yE7AIftvTgdM1br8B7gY=";
  };

  postPatch = ''
    substituteInPlace SConstruct --replace "/usr/bin/g++" "g++"
    substituteInPlace SConstruct --replace "['include']" "'${openmpi-dynres}/include'"
  '';

  nativeBuildInputs = [ scons openmpi-dynres ];

  buildInputs = [ ];

  buildPhase = ''
    export LD_LIBRARY_PATH=${openmpi-dynres}/lib
    scons example=DynMPISessions_v2a compileMode=release
   '';
  
  installPhase = ''
    cp -a build $out/
  '';
  meta = with lib; {
    description = "Time-X EuroHPC project: miniapps";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

