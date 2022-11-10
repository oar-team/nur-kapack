{ stdenv, lib, pkgs, fetchFromGitLab, bash, cmake, pkg-config, gfortran, python3, zeromq, openmpi, libsodium, ghc }: # pandoc, ghc }:

stdenv.mkDerivation rec {
  pname =  "melissa";
  version = "0.7.1";

  # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined;
  src = builtins.fetchGit {
     url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
     rev = "5f1757d966e8c09b874102f9f1479a432d67b633";
     narHash = "sha256-oE4uKQZcl/0o0VmoInmdqABvxP3k4OZENNgZBpRS728=";
     allRefs = true;
  };

  buildInputs = with pkgs; [ cmake gfortran python3 openmpi zeromq pkg-config libsodium ];

  cmakeBuildType = "Release";
  enableParallelBuilding = false;
  dontUseCmakeBuildDir = false;

  postBuild = ''
    for f in $(find $out/bin/ -type f -executable); do
      wrapProgram "$f" \
        --prefix PATH ":" ${lib.makeBinPath [ pname ]}
        --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ pname ]}
    done
  '';

  postInstall = ''
    #substituteInPlace $out/bin/melissa-launcher --replace "python3" "${python3}/bin/python3"
    #substituteInPlace $out/share/melissa/melissa/launcher/job_management.py --replace "/bin/sh" "${bash}/bin/sh"
    #substituteInPlace $out/share/melissa/melissa/scheduler/slurm.py --replace "/bin/sh" "${bash}/bin/sh"
    #patchShebangs $out
  '';

  meta = with lib; {
    homepage = "https://melissa-sa.github.io/";
    description = "Melissa is a file avoiding, adaptive, fault tolerant and elastic framework, to run large scale sensitivity analysis on supercomputers";
    license = licenses.bsd3;
    broken = false;
  };
}
