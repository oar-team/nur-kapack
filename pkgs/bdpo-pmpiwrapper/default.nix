{ stdenv, lib, openmpi }:

stdenv.mkDerivation rec {
  pname =  "bdpo";
  version = "4.1.0";

  src = builtins.fetchGit {
    url = "git@gricad-gitlab.univ-grenoble-alpes.fr:regale/tools/bdpo?ref=main";
    rev = "edebce50639d6a01e2bbae813ba1bcdb92f71fb1";
  };
  
  nativeBuildInputs = [ ];
  
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
    #license = lib.licenses.unfree;
  };
}
