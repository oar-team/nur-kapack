{ batexpe }:

batexpe.overrideAttrs (attrs: rec {
  version = "master";
  src = builtins.fetchGit {
    url = "https://framagit.org/batsim/batexpe.git";
    ref = "master";
  };
})
