{ simgrid }:

simgrid.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball "https://framagit.org/simgrid/simgrid/repository/master/archive.tar.gz";
})
