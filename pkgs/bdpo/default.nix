{ stdenv, lib, fetchgit, autoPatchelfHook, rpmextract, openmpi }:

stdenv.mkDerivation rec {
  pname =  "bdpo";
  version = "4.1.1";
  #src = "/home/orichard/bdpo";
  src = fetchgit {
    url = "git@gricad-gitlab.univ-grenoble-alpes.fr:regale/tools/bdpo";
    rev = "fc2a819b1351473f6bd4144098af461a2e03803c";
    sha256 = "1m716warxqdswp80wn3k0qniccb9csr5y8yk4749cn7dslcaia5c";
  };
  
  nativeBuildInputs = [
    autoPatchelfHook
    rpmextract
  ];
  
  buildInputs = [ openmpi ];
  dontBuild = true;
  dontConfigure = true;
  
  unpackPhase = ''
  rpmextract ${src}/rpm/bull-dynamic-power-optimizer-2.2-Bull.1.66.2.20220627095402.el8.x86_64.rpm
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/bin $out
    cp -r etc $out
  '';  
   
  meta = with lib; {
    description = "BDPO";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
}
