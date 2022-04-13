{ stdenv, lib, fetchFromGitLab, bash, cmake, pkg-config, gfortran, python3, zeromq, openmpi, libsodium, ghc }: # pandoc, ghc }:

stdenv.mkDerivation rec {
  pname =  "melissa";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "melissa";
    repo = "melissa";
    rev = "e6d09dbb4785e074ed91ad3b46d5a1576aed7b2f";
    sha256 = "sha256-IiJadcplNdy4o1xK9LXvD0rvNrWYJKFgYg8o7KDHlNM";
  };

  buildInputs = [ cmake gfortran python3 openmpi zeromq pkg-config libsodium ];

  cmakeBuildType = "Release";
  enableParallelBuilding = false;
  dontUseCmakeBuildDir = true;

  postBuild = ''
    for f in $(find $out/bin/ -type f -executable); do
      wrapProgram "$f" \
        --prefix PATH ":" ${lib.makeBinPath [ pname ]}
        --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ pname ]}
    done
  '';

  postInstall = ''
    substituteInPlace $out/bin/melissa-launcher --replace "python3" "${python3}/bin/python3"
    substituteInPlace $out/share/melissa/melissa/launcher/job_management.py --replace "/bin/sh" "${bash}/bin/sh"
    substituteInPlace $out/share/melissa/melissa/scheduler/slurm.py --replace "/bin/sh" "${bash}/bin/sh"
    patchShebangs $out
  '';

  meta = with lib; {
    homepage = "https://melissa-sa.github.io/";
    description = "Melissa is a file avoiding, adaptive, fault tolerant and elastic framework, to run large scale sensitivity analysis on supercomputers";
    license = licenses.bsd3;
    platforms = ghc.meta.platforms;
    broken = false;
  };
}
