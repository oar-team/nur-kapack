{ lib
, stdenv
, fetchFromGitLab
, perl
, autoconf
, removeReferencesTo
  #, autoconf-archive
, automake
  #, pkg-config  
, libtool
, gitMinimal
, flex
, libevent
, hwloc
, pmix
, python3
, zlib
, oac # to replace submodule
}:

stdenv.mkDerivation rec {
  pname = "prrte";
  version = "4.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = pname;
    rev = "2abf4f2fb9cd9d0c05172ab1d4b4123607e02dab";
    sha256 = "sha256-qarhtCKENq64sdwfnDG3v7CKWgAZ8ldBU3NiEtnWr+w=";
    # fetchSubmodules = true; # does not work because oac is located at Github 
  };


  Outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs ./autogen.pl ./config
    cp -a ${oac}/* config/oac/ #replace submodule
  '';

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    moveToOutput "bin/prte_info" "''${!outputDev}"
    # Fix a broken symlink, created due to FHS assumptions
    rm "$out/bin/pcc"
    ln -s ${lib.getDev pmix}/bin/pmixcc "''${!outputDev}"/bin/pcc

    remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libprrte${stdenv.hostPlatform.extensions.library})
  '';

  nativeBuildInputs = [
    removeReferencesTo
    perl
    python3
    autoconf
    automake
    libtool
    flex
    gitMinimal
  ];

  buildInputs = [
    libevent
    hwloc
    zlib
    pmix
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Time-X EuroHPC project: Dynamic Runtime Environment Extensions (based on PRRTE)";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

