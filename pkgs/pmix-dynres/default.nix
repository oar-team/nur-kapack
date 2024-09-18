{ lib, stdenv, fetchFromGitLab, perl, autoconf, automake
, libtool, flex, libevent, hwloc, munge, zlib, pandoc, python3, pkgconf
} :

stdenv.mkDerivation rec {
  pname = "openpmix";
  version = "5.0.0a1";
  
  # src = fetchFromGitHub {
  #   repo = "openpmix";
  #   owner = "openpmix";
  #   rev = "v${version}";
  #   sha256 = "sha256-79zTZm549VRsqeziCuBT6l4jTJ6D/gZaMAvgHZm7jn4=";
  # };
 
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = pname;
    rev = "d5713fde7f998f863690388b9bc6d38a65076936";
    sha256 = "sha256-7rJpVEb9UG3tfAEhDXKF2UXRTUtLW2tM2rAZJzDkQgo=";
  };
  
  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [ pandoc perl autoconf automake libtool flex python3 pkgconf python3.pkgs.cython ];

  buildInputs = [ libevent hwloc munge zlib ];

  configureFlags = [
    #"--with-libevent=${libevent}"
    "--with-munge=${munge}"
    "--with-hwloc=${hwloc.dev}"
    "--enable-python-bindings"
  ];

  preConfigure = ''
    ./autogen.pl
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

