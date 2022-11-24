{ stdenv, lib, fetchgit, autoPatchelfHook, rpmextract, openmpi }:

stdenv.mkDerivation rec {
  pname = "bdpo";
  version = "4.1.0";

  src = builtins.fetchGit {
    url = "git@gricad-gitlab.univ-grenoble-alpes.fr:regale/tools/bdpo?ref=main";
    rev = "edebce50639d6a01e2bbae813ba1bcdb92f71fb1";
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
    #license = lib.licenses.unfree;
  };
}
