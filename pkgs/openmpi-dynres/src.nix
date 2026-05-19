{ fetchFromGitLab }: {
  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    group = "dynres";
    owner = "dyn-procs";
    repo = "ompi";
    rev = "a8b3cc547e4fefa530da60d679d412e02f6bee75";
    sha256 = "sha256-dgD9POdUi0hQTF4OovW9YhhoGlg3D+vP+yUedheJ920=";
  };
}

