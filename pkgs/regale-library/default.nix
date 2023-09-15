{ stdenv, lib, cmake, fastdds, buildExamples ? false }:

stdenv.mkDerivation rec {
  pname = "regale-library";
  version = "1.0";

  src = builtins.fetchGit {
     url = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale.git";
     rev = "fa4ec6b192c514760e639d1a436b05839a021105";
     ref = "regale_nm_ear";
  };

  patches = [ ./temporary_patch.patch ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fastdds
  ];

  # Examples are broken with recent changes
  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON"  "-DREGALE_EXAMPLES=${if buildExamples then "ON" else "OFF"}" ];

  meta = with lib; {
    description = "Regale published subscribed library.";
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

