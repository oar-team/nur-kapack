{ oar }:

oar.overrideAttrs (attrs: rec {
  version = "master";
  src = fetchTarball {url="https://github.com/oar-team/oar3/archive/402aaeb032b081aa061997a4158951a340becf77.tar.gz"; sha256 = "sha256-BRqFpc/5yY0xZ3VpbeRkAeAQ+aso9ywX8JJHadrm2kM=";};
})
