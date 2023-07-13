{ stdenv, lib, cmake, automake, ninja, asio, tinyxml-2, openssl, fastcdr, foonathan-memory }:

stdenv.mkDerivation rec {
  pname = "fastdds";
  version = "1.0.27";

  src = fetchTarball { url = "https://github.com/eProsima/Fast-DDS/archive/v2.10.1.tar.gz";
    sha256= "1c1g2zk6m32nsaf362syv99bf2crz7xfhl6lgagcwx6naffd3cmq";};

  nativeBuildInputs = [ cmake automake ninja ];
  buildInputs = [
    asio
    tinyxml-2
    openssl
    foonathan-memory
    fastcdr
  ];

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

