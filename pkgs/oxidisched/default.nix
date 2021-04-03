{ stdenv, rustPlatform, fetchgit, pkgconfig, zeromq }:

rustPlatform.buildRustPackage rec {
  pname = "oxidisched";
  version = "0.1-unreleased";

  src = fetchgit {
    url = "https://gitlab.inria.fr/batsim/oxidisched.git";
    rev = "2c80194015963460c5eed5f3222a4ccb4e2f3ec1";
    sha256 = "1iln6cc39czl8nwm6q97cmr1ximzf4fvmzs65v3afhpw5x7v8fjz";
  };

  buildInputs = [ zeromq ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "sha256:0yk5hl6zwpxdadi7r4zaqilsxbfawsmfka24vhjh0g0c4f9p8ais";

  meta = with stdenv.lib; {
    homepage = https://gitlab.inria.fr/batsim/oxidisched;
    description = "Batsim-compatible schedulers mostly meant to test Batsim. Written in Rust.";
    license = licenses.lgpl3;
    broken = false;
  };
}
