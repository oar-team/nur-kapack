{ lib, stdenv, fetchFromGitLab, perl, autoconf, automake, libtool, flex, libevent, hwloc, pmix
} :

stdenv.mkDerivation rec {
  pname = "prrte";
  version = "4.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = pname;
    rev = "ac4279b9185097de2f0c73967f8fcf355f128dba";
    sha256 = "sha256-DngiLUH0vGiowh9lWBolliHx5dOsfJcOtHUSTeMF5m0=";
  };
  
  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
    substituteInPlace src/mca/ras/base/ras_base_allocate.c  --replace "prte_clean_output, ptr" "prte_clean_output, '%s', ptr"
  '';

  nativeBuildInputs = [ perl autoconf automake libtool flex ];

  buildInputs = [ libevent hwloc pmix ];

  configureFlags = [
    "--with-pmix=${pmix}"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Time-X EuroHPC project: Dynamic Runtime Environment Extensions (based on PRRTE)";
    homepage = "";
    #license = licenses.bsd3;
    #maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

