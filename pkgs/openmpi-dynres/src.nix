{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "f634cad4ab112590ac40f69c2e0e08b10dbad767";
    sha256 = "sha256-cfVWGXZeKOnPFuMhzuK4RRCdg9W2QODdtPwxkylrgGw=";
  };
}

