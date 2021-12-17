{ stdenv, lib, fetchgit, cmake, pkg-config, gfortran, python37, zeromq, openmpi, libsodium, pandoc }:

stdenv.mkDerivation rec {
  name =  "melissa-${version}";
  version = "0.7.1";

  src = fetchgit {
    url = "https://gitlab.inria.fr/melissa/melissa.git";
    rev = "e6d09dbb4785e074ed91ad3b46d5a1576aed7b2f";
    sha256 = "sha256-IiJadcplNdy4o1xK9LXvD0rvNrWYJKFgYg8o7KDHlNM";
  };

  buildInputs = [ cmake gfortran python37 openmpi zeromq pkg-config libsodium ];
  propagatedBuildInputs = [ pandoc ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release ${src}" ];
  enableParallelBuilding = false;
  dontUseCmakeBuildDir = true;

  postBuild = ''
    for f in $(find $out/bin/ -type f -executable); do
      wrapProgram "$f" \
        --prefix PATH ":" ${lib.makeBinPath [ name ]}
        --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ name ]}
    done
  '';

  postInstall = ''
    substituteInPlace $out/bin/melissa-launcher --replace "python3" "${python37}/bin/python3"
  '';
  
  meta = with lib; {
    homepage = "https://melissa-sa.github.io/";
    description = "Melissa is a file avoiding, adaptive, fault tolerant and elastic framework, to run large scale sensitivity analysis on supercomputers";
    license = licenses.bsd3;
    #platforms = ghc.meta.platforms;
    platforms = platforms.linux;
  };
}
