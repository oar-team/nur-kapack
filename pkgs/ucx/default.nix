{ ucx, fetchFromGitHub }:

ucx.overrideAttrs (attrs: rec {
  version = "1.15";
  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v${version}";
    sha256 = "sha256-oAigiCgbr27pX+kNl+RW1P10TKYFSKrHDK4U4z8WMko=";
  };
})
