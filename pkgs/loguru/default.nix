{ stdenv, lib, fetchFromGitHub
, cmake
, debug ? false
, optimize ? (!debug)
}:

stdenv.mkDerivation rec {
  pname = "loguru";
  version = "4adaa18";

  src = fetchFromGitHub {
    owner = "emilk";
    repo = "loguru";
    rev = "4adaa185883e3c04da25913579c451d3c32cfac1";
    sha256 = "sha256-NpMKyjCC06bC5B3xqgDr2NgA9RsPEeiWr9GbHrHHzZ8=";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    # to set the hpp file under `include` and not `include/loguru` to not break batsched
    ln -s $out/include/loguru/loguru.hpp $out/include/loguru.hpp
  '';

  meta = with lib; {
    description = "A header-only C++ logging library";
    longDescription = "A lightweight and flexible C++ logging library.";
    homepage = https://github.com/emilk/loguru;
    platforms = platforms.all;
    license = licenses.publicDomain;
    broken = false;
  };
}
