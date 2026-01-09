{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "737018099bf92491ed5926f83e5dd6b4aea59aef";
    sha256 = "sha256-pWzHBScSsemX6BM4flI9pSX5IYCSkCdEXhkyHN0xNf8=";
  };
}

