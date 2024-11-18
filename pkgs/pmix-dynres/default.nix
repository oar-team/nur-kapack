{ lib
, stdenv
, fetchFromGitLab
, perl
, autoconf
, automake
, removeReferencesTo
, libtool
, python3
, flex
, libevent
, targetPackages
, makeWrapper
, hwloc
, munge
, zlib
, pandoc
, gitMinimal
, oac # to replace submodule 
}:

stdenv.mkDerivation rec {
  pname = "openpmix";
  version = "5.0.0a1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = pname;
    rev = "6f0982e76127a53d329a13dffe26ddc3cfb0e05e";
    sha256 = "sha256-7aYLoDqNCTi0EXEKHjgy5y2VLX6tyqon8liGzB58Ris=";
    #fetchSubmodules = true; # does not work because oac is located at Github
  };

  outputs = [ "out" ] ++ lib.optionals stdenv.isLinux [ "dev" ];

  postPatch = ''
    patchShebangs ./autogen.pl ./config
    cp -a ${oac}/* config/oac/ #replace submodule
  '';

  nativeBuildInputs = [
    pandoc
    perl
    autoconf
    automake
    libtool
    flex
    gitMinimal
    python3
    removeReferencesTo
    makeWrapper
    python3.pkgs.cython
    python3.pkgs.setuptools
  ];

  buildInputs = [
    libevent
    hwloc
    munge
    zlib
  ];

  configureFlags = [
    "--with-libevent=${lib.getDev libevent}"
    "--with-libevent-libdir=${lib.getLib libevent}/lib"
    "--with-munge=${munge}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-hwloc-libdir=${lib.getLib hwloc}/lib"
    "--enable-python-bindings"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall =
    ''
      find $out/lib/ -name "*.la" -exec rm -f \{} \;

      moveToOutput "bin/pmix_info" "''${!outputDev}"
      moveToOutput "bin/pmixcc" "''${!outputDev}"
      moveToOutput "share/pmix/pmixcc-wrapper-data.txt" "''${!outputDev}"

    ''
    # From some reason the Darwin build doesn't include this file, so we
    # currently disable this substitution for any non-Linux platform, until a
    # Darwin user will care enough about this cross platform fix.
    + lib.optionalString stdenv.isLinux ''
      # Pin the compiler to the current version in a cross compiler friendly way.
      # Same pattern as for openmpi (see https://github.com/NixOS/nixpkgs/pull/58964#discussion_r275059427).
      substituteInPlace "''${!outputDev}"/share/pmix/pmixcc-wrapper-data.txt \
        --replace compiler=gcc \
          compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc
    '';

  postFixup = lib.optionalString (lib.elem "dev" outputs) ''
    # The build info (parameters to ./configure) are hardcoded
    # into the library. This clears all references to $dev/include.
    remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libpmix.so)

    # The path to the pmixcc-wrapper-data.txt is hard coded and
    # points to $out instead of dev. Use wrapper to fix paths.
    wrapProgram "''${!outputDev}"/bin/pmixcc \
      --set PMIX_INCLUDEDIR "''${!outputDev}"/include \
      --set PMIX_PKGDATADIR "''${!outputDev}"/share/pmix
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}


