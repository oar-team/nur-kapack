{ lib, rustPlatform, fetchFromGitHub, pkgconfig, zeromq, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "colmet-rs";
  version = "0.0.1";

  #src = fetchFromGitHub {
  #    owner = "Meandres";
  #    repo = pname;
  #    rev = "05201510d594801eae3c65693aab49bcfbf5d37f";
  #    sha256 = "sha256-EYMSoQrkpLTvMiaZUeMSv4Ja8k5wEHvy1Je+XMDDWzE";
  #};

  src = /home/imeignanmasson/colmet-rs;
  
  buildInputs = [ zeromq ];
  nativeBuildInputs = [ pkgconfig cmake ];
  
  #cargoSha256 = "sha256-M9CinPary/jLB6wvp1B+ytKCybE7ViM3dXeHZgSgJhQ=";
  cargoLock = {
    lockFile = /home/imeignanmasson/colmet-rs/Cargo.lock;
  };

  meta = with lib; {
    homepage = https://github.com/oar-team;
    description = "Monitoring processes inside cgroup";
    license = licenses.lgpl2;
    # broken = true;
  };
}
