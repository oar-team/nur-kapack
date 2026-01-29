{pkgs ? import <nixpkgs> {}, ...}:
pkgs.fetchzip rec {
  pname = "scipoptsuite-src";
  version = "9.0.1";

  name = "${pname}-${version}";

  url = "https://scipopt.org/download/release/scipoptsuite-${version}.tgz";
  hash = "sha256-dc2NczLSgc7f48QCqZfRC4nOGov57B5ovoqSMIt51NI=";
}
