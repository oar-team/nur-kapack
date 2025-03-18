{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "798e35daef82fc3317e17f39bed0654d7e9f3d09";
    sha256 = "sha256-Xn2NJokOM4JnHwaV+qjlXFtY+asavzQ7CT0T5wb2iME=";
  };
}

