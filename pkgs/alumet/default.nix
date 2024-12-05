{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, libclang, protobuf }:

rustPlatform.buildRustPackage rec {
  pname = "alumet";
  version = "0.6.1";

  src = fetchFromGitHub {
     owner = "alumet-dev";
     repo = pname;
     rev = "79df2fb4b3f81b8b513c1d402608bc44c37eae6d";
     hash = "sha256-l7bEgiVCDqKg96c9iBm50olucdeKOofqRPNGxtSwCLo=";
  };
  
  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];
  
  buildInputs = [
    openssl
    libclang
    protobuf
  ];

  cargoBuildFlags = [
    "--bin alumet-local-agent --features local_x86"
    "--bin alumet-relay-client --features relay_client"
    "--bin alumet-relay-server --features relay_server"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false; # issue on client_to_server_to_csv_ipv4 and client_to_server_to_csv_ipv6 tests

  meta = with lib; {
    homepage = https://github.com/alumet-dev/alumet;
    description = "Customizable and efficient tool for distributed measurement of energy consumption and performance metrics..";
    license = licenses.lgpl2;
  };
}
