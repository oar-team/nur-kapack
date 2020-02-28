{ pybatsim }:

pybatsim.overrideAttrs (attr: rec {
  version = "master";
  src = fetchTarball "https://gitlab.inria.fr/batsim/pybatsim/repository/master/archive.tar.gz";
})
