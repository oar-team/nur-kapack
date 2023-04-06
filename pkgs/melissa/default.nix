{ stdenv, lib, pkgs, fetchFromGitLab, bash, cmake, pkg-config, gfortran, python3, zeromq, openmpi, libsodium, ghc }: # pandoc, ghc }:

stdenv.mkDerivation rec {
  pname =  "melissa";
  version = "0.7.1";

  # src = /home/adfaure/Sandbox/nxc-melissa/melissa-combined;
  src = builtins.fetchGit {
    url = "ssh://git@gitlab.inria.fr/melissa/melissa-combined.git";
    rev = "c2fbcc0e19c773e81e4ba2d3860f37c012902da1";
    narHash = "sha256-OoKOazJb5vyHqMoylECT8BFfqSIpgi+iu0fApRuHWwM=";
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
