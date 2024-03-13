{ stdenv, lib, cmake, fastdds, buildExamples ? false }:

stdenv.mkDerivation rec {
  pname = "regale-library";
  version = "1.0";

  src = builtins.fetchGit {
     url = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale.git";
     rev = "7b673fb52bb9aee90f1f9d2b01823ee80dd694e8";
     ref = "regale_nm_ear";
  };

  # patches = [ ./temporary_patch.patch ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fastdds
  ];

  postPatch = ''
    for file in src/**/*; do
      substituteInPlace $file \
        --replace /usr/local $out;
    done
  '';

  postInstall = ''
    mkdir -p $out/share
    cp ../examples/spm_bindings.py $out/share/

    sed -i "s#/usr/local/lib/#$out/lib/#g" $out/share/spm_bindings.py
    chmod +x $out/share/spm_bindings.py
  '';

  # Examples are broken with recent changes
  # TODO update
  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON"  "-DREGALE_EXAMPLES=${if buildExamples then "ON" else "OFF"}" ];

  meta = with lib; {
    description = "Regale published subscribed library.";
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

