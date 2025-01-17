{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "a3ebc28f8212c88046f4c0386c5309c462d95a21";
    sha256 = "sha256-rslQtEPxgmyCNSGc6IsWcZPyyM7AHoa1Su7cx3L4JTA=";
  };
}
