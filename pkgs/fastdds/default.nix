{ stdenv, lib, cmake, automake, ninja, asio, tinyxml-2, openssl, fastcdr, foonathan-memory }:

stdenv.mkDerivation rec {
  pname = "fastdds";
  version = "2.10.1";

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
    description = "eprosima Fast DDS (formerly Fast RTPS) is a C++ implementation of the DDS
    (Data Distribution Service) standard of the OMG (Object Management Group).
    eProsima Fast DDS implements the RTPS (Real Time Publish Subscribe) protoco";
    longDescription = """eprosima Fast DDS (formerly Fast RTPS) is a C++ implementation of the DDS
    (Data Distribution Service) standard of the OMG (Object Management Group).
    eProsima Fast DDS implements the RTPS (Real Time Publish Subscribe) protocol,
    which provides publisher-subscriber communications over unreliable transports
    such as UDP, as defined and maintained by the Object Management Group (OMG) consortium.""";
    homepage = "https://www.eprosima.com/";
    platforms = platforms.all;
    license = licenses.free;
    broken = false;
  };
}

