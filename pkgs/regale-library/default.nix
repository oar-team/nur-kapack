{ stdenv, lib, cmake, fastdds }:

stdenv.mkDerivation rec {
  pname = "regale-library";
  version = "1.0";

  src = builtins.fetchGit {
     url = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale.git";
     #rev = "7b673fb52bb9aee90f1f9d2b01823ee80dd694e8";
     rev = "e7e98805c3a57e8b10ae62a97fe8e3b187666c60";
     ref = "regale_nm_ear";
  };

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
  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];
 
  meta = with lib; {
    description = "Regale published subscribed library.";
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/regale/tools/regale";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

