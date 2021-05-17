{ pybatsim }:

pybatsim.overrideAttrs (attr: rec {
  version = "master";
  src = builtins.fetchGit {
    url = "https://gitlab.inria.fr/batsim/pybatsim.git";
    ref = "master";
  };
})
