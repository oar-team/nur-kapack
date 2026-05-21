{ lib
, stdenv
, fetchFromGitLab
, openmpi-dynres

, autoconf
, automake
, pkg-config

, dyn_psets
, ulfius
, jansson
, curl
, yder
, libmicrohttpd
, zlib
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "dtg";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "dyntaskgraphs";
    rev = "d47887e0d93344ceecfbd066bb65bcab63fabf26";
    sha256 = "sha256-8zgf+0sDhkVXhYMDU2o8A173cLZdovhQJnJ4JZ0ALPQ=";
  };

  buildInputs = [
    openmpi-dynres
    dyn_psets
    ulfius
    jansson
    curl
    yder
    libmicrohttpd
    zlib
  ];

  nativeBuildInputs = [
    openmpi-dynres
    autoconf
    automake
    pkg-config
    autoPatchelfHook
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  buildPhase = ''
    make dtg
  '';

installPhase = ''
  # $out is the unique path in /nix/store assigned to this package
  mkdir -p $out/bin 
  mkdir -p $out/lib 
  mkdir -p $out/include
  cp src/build/bin/* $out/bin
  cp src/build/lib/* $out/lib
  cp src/include/* $out/include
'';

  meta = with lib; {
    description = "Time-X EuroHPC project: dyn_psets";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
