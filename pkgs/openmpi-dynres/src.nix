{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "87925c07b76978dc323921d336fb2595bbef29ae";
    sha256 = "sha256-XTUwqKzEshA/a64roaFhLmqG/6nqS/9/QujILVXNTg4=";
  };
}
