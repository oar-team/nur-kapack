{ stdenv, lib, fetchgit , rpmextract, python39, python39Packages }:

stdenv.mkDerivation rec {
  pname =  "beo";
  version = "4.1.0";
  src = /home/auguste/dev/beo;
  # src1 = fetchgit {
  #   url = "git@gricad-gitlab.univ-grenoble-alpes.fr:regale/tools/beo";
  #   rev = "d3eb70d258988d722adc188ec19fc9fe57098676";
  #   sha256 = "";
  # };
  
  nativeBuildInputs = [
    rpmextract
    python39Packages.wrapPython
  ];
  
  dontBuild = true;
  dontConfigure = true;
  
  unpackPhase = ''rpmextract $src/rpm/powerefficiency-eo-engine-$version-dev.python39.el8.noarch.rpm'';
  
  installPhase = ''
    mkdir -p $out
    #chmod 777 usr/bin/beo
    cp -r usr/bin $out
    cp -r usr/lib $out
    cp -r etc $out    
  '';

  postFixup = ''
    for f in $out/bin/*
    do
      echo "Handle $f"
      if head -n1 "$f" | grep -q '#!.*python'; then
        echo "Rewriting Shebang for $f" 
        sed -i "$f" -e "1 s^.*python[^ ]*^#!${python39}/bin/python^"
      fi
    done
  '';
  
  meta = with lib; {
    description = "BEO";
    #sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    #license = lib.licenses.unfree;
  };
}
