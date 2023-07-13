{ stdenv, lib, cmake }:

stdenv.mkDerivation rec {
  pname = "fastcdr";
  version = "1.0.27";

  src = fetchTarball { url = "https://github.com/eProsima/Fast-CDR/archive/v1.0.27.tar.gz";
    sha256= "0g83yxslv3a0v6w8qz24c93s2zqxdnifmfj5svrj6p3bqd0qaxb2";};

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "eProsima Fast CDR is a C++ library that provides two serialization mechanisms.";
    longDescription = """eProsima Fast CDR is a C++ library that provides two serialization mechanisms.
    One is the standard CDR serialization mechanism, while the other is a
    faster implementation that modifies the standard.""";
    homepage = "https://www.eprosima.com/";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

