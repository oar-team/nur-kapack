{ stdenv, lib, autoreconfHook, fetchFromGitLab, perl }:

stdenv.mkDerivation rec {
  pname = "taktuk";
  version = "3.7.7";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "${pname}";
    repo = "${pname}";
    rev = "dcd763e389a414f540b43674cbc63752176f1ce3";
    sha256 = "sha256-CerOBn1VDiKFLaW2WXv6wLxfcqy1H3dlF70lrequbog=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl ];

  # manually set the perl interpreter to keep options given on shabang line
  patchPhase = ''
    find . \
      -type f \
      -exec sed -i -e 'sW#!\s*/usr/bin/perlW#!${perl}/bin/perlWg' {} \;
  '';

  meta = with lib; {
    description = "A tool for large scale remote execution deployment";
    longDescription = ''
TakTuk is a tool for broadcasting the remote execution of one ore
more command to a set of one or more distant machines. TakTuk
combines local parallelization (using concurrent deployment processes)
and work distribution (using an adaptive work-stealing algorithm)
to achieve both scalability and efficiency.

TakTuk is especially suited to interactive tasks involving several
distant machines and parallel remote executions. This is the case
of clusters administration and parallel program debugging.  See
taktuk(1) for a detailled description and more examples.

TakTuk also provides a basic communication layer to programs it
executes.  This communication layer uses the communication
infrastructure set up by TakTuk during its deployment. It is available
both for the Perl and the C langages and is described in taktukcomm(3).

For a quick introduction to the world of TakTuk, the file "sample_session.txt"
included with this distribution contains the output of a small toy session of
various commands execution using TakTuk.
    '';
    homepage = https://gitlab.inria.fr/taktuk/taktuk;
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = false;
  };
}
