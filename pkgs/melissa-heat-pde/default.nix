{stdenv, lib, melissa, cmake, gfortran, openmpi, python37 }:

stdenv.mkDerivation rec {
    name = "heat-pde";
    version = "0.0.0";

    src = "${melissa}/share/melissa/examples/heat-pde";

    buildInputs = [ melissa cmake gfortran openmpi python37 ];

    postInstall = ''
        mkdir -p $out
        cp -r ${src}/*.py $out
        chmod +x $out/*.py
    '';

    meta = with lib; {
        homepage = "https://melissa-sa.github.io/";
        description = "Melissa framework example - heat equation";
        platforms = platforms.linux;
    };
}
