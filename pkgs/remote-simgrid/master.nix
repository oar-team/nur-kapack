{ rsg }:

rsg.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball "https://framagit.org/simgrid/remote-simgrid/repository/master/archive.tar.gz";
})
