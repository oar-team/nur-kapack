{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, python3
, git
, backend ? "dynpkgs"
, env ? "None"
}:

stdenv.mkDerivation rec {
  pname = "dynpkgs";
  version = "0.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "dyn_procs_setup";
    rev = "db0d22fa6f5348f1f4e59652c4f1f12967cc44b2";
    sha256 = "sha256-ccu8jHuK2yvBNip8ZkzV5lFM3QgBL2dVMTLKgm1EJ1U=";
  };

  spack = fetchFromGitHub {
    owner = "spack";
    repo = "spack";
    rev = "cbbee7faff85a1a32558bfe46ae0ad79c4e00983";
    sha256 = "sha256-v/74doaLrF8wr/Hdn/NShYRl+Je9oqwghfVKGz3lLF8=";
  };

  nativeBuildInputs = [
    python3
    python3.pkgs.pyyaml
    git
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a . $out/
    mkdir -p $out/backend/install/spack/spack
    echo "****************++"
    ls -R ${spack} 
    echo "****************=="
    cp -a ${spack}/. $out/backend/install/spack/spack
    chmod u+w $out/backend/install/spack/spack/share/spack
    chmod u+w $out/backend/install/spack/spack/share/spack/setup-env.sh
    sed -i 's|source \$_sp_share_dir/spack-completion.bash|echo "replaced source spack-completion.bash"|g' $out/backend/install/spack/spack/share/spack/setup-env.sh
    source $out/bin/dynpkgs.sh
    echo "Installing ${env}"
    dynpkgs env_install "${env}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynpkgs: Package Manager for Dynamic Resource Mangaement software";
    homepage = "https://dynres.readthedocs.io/projects/DynPkgs/en/latest/";
    #license = licenses.;
    #maintainers = [  ]; # Dominik Huber
    platforms = platforms.linux;
  };
}
