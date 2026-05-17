{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "a8b3cc547e4fefa530da60d679d412e02f6bee75";
    sha256 = "sha256-pWzHBScSsemX6BM4flI9pSX5IYCSkCdEXhkyHN0xNf8=";
  };
}

