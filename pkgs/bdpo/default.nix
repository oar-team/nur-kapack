{ stdenv, lib, fetchgit, autoPatchelfHook, rpmextract, openmpi }:

stdenv.mkDerivation rec {
  pname = "bdpo";
  version = "4.1.0";
  #src = /home/auguste/dev/bdpo;
  src1 = fetchgit {
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
    for i in 4.1.0-0 slurm-addons-4.0.1-0 translator-4.1.0-0
    do
      rpmextract $src/rpm/powerefficiency-dpo-$i.el8.x86_64.rpm
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/bin $out
    cp -r etc $out
    cp -r usr/lib64/slurm $out  
  '';

  meta = with lib; {
    description = "BDPO";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
}
