# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gocovmerge-unstable-${version}";
  version = "2016-03-31";

  goPackagePath = "github.com/wadey/gocovmerge";

  src = fetchFromGitHub {
    owner = "wadey";
    repo = "gocovmerge";
    rev = "b5bfa59ec0adc420475f97f89b58045c721d761c";
    sha256 = "00m7kxcmmw0l9z0m7z6ii06n5j4bcrxqjbhxjbfzmsdgdsvkic31";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    broken = false;
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mpoquet ];
    license = licenses.bsd2;
    homepage = "https://github.com/wadey/gocovmerge";
  };
}
