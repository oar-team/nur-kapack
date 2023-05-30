{ oar }:

oar.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball "https://github.com/oar-team/oar3/archive/402aaeb032b081aa061997a4158951a340becf77.tar.gz";
})
