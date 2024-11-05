{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "e1a25cdb7e7a97aea0c1ab6c390a90f5ecaa74f4";
    sha256 = "sha256-ZhTjr2Kvb69q8NgWxM9vKzb61PwUedhcm0MGhmILvDc=";
  };
}
