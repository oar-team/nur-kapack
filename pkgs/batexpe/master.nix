{ batexpe }:

batexpe.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball "https://gitlab.inria.fr/batsim/batexpe/repository/master/archive.tar.gz";
})
