{ simgrid }:

simgrid.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball "https://gitlab.inria.fr/simgrid/simgrid/repository/master/archive.tar.gz";
})
