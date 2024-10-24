{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "44d86bcf72dad3a667f1aca9728a80b1efcf59bf";
    sha256 = "sha256-6zPH1F3A2oVCOSwl3xlv0T7iUw+x3wvjikVKKD+MATc=";
  };
}
