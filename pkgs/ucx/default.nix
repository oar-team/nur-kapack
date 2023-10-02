{ ucx, fetchFromGitHub }:

ucx.overrideAttrs (attrs: rec {
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucx";
    rev = "v1.15.0";
    sha256 = "sha256-VxIxrk9qKM6Ncfczl4p2EhXiLNgPaYTmjhqi6/w2ZNY=";
  };
})
