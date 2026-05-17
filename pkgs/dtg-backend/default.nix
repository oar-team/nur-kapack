{ lib
, stdenv
, maven
, fetchFromGitLab
}:

maven.buildMavenPackage {
  pname = "dtg-backend";
  version = "0.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "applications";
    repo = "dyntaskgraphs";
    rev = "136c224f0fc2155abdbd52e6a2c4ed9b29a2fab6";
    sha256 = "sha256-rshE9UE9VZ7OyDRFU+YffLwiat62OiloeD/fUEvWhew=";
  };

  sourceRoot = "source/src/backend";   # ← where pom.xml lives

  mvnHash = "sha256-nKk9G5YQoDEr31c7PhOne2ro79kponmuvAd2fuoWFsM=";

  installPhase = ''
    mkdir -p $out/lib
    cp target/*.jar $out/lib/dtg_backend.jar
  '';

}
