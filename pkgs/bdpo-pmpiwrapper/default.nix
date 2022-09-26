{ stdenv, lib, fetchgit , openmpi }:

stdenv.mkDerivation rec {
  pname =  "bdpo";
  version = "4.1.0";
  src = /home/auguste/dev/bdpo;
  # src1 = fetchgit {
  #   url = "git@gricad-gitlab.univ-grenoble-alpes.fr:regale/tools/bdpo";
  #   rev = "fc2a819b1351473f6bd4144098af461a2e03803c";
  #   sha256 = "1m716warxqdswp80wn3k0qniccb9csr5y8yk4749cn7dslcaia5c";
  # };
  
  nativeBuildInputs = [
  ];
  
  buildInputs = [ openmpi ];
  
  dontConfigure = true;
  
  buildPhase = ''
  cd code/powerefficiency-dpo-pmpiwrapper/SOURCE/C/lib
  make
  '';
  
  installPhase = ''
  mkdir -p $out/lib
  cp bdpopmpiwrapper.so $out/lib
  '';  
   
  meta = with lib; {
    description = "BDPO pmpiwrapper";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
}
