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
    rev = "31894a825c85aa2b6000d3c4b722b5a9d3852229";
    sha256 = "sha256-3ZzuLEB497A47tlXg6s2JXBvZiYtoIrQ3XrDDt150m8";
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

