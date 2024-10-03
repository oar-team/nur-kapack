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
    rev = "ca4573259a3268a62ca6cf88ae9e0d703b853580";
    sha256 = "sha256-IJyqQtmVW55mfWHZJzTxVLE2ZJ9d2LigIrlnQc5mScI=";
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

