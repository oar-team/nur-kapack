{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "foonathan-memory";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "foonathan";
    repo = "memory";
    rev = "0f0775770fd1c506fa9c5ad566bd6ba59659db66";
    sha256 = "sha256-nLBnxPbPKiLCFF2TJgD/eJKJJfzktVBW3SRW2m3WK/s=";
  };
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DFOONATHAN_MEMORY_BUILD_TESTS=OFF"];
 # TODO patch to comment test/CMakeLists.txt to exclude FetchContent or insert/use doctest
  
   meta = with lib; {
    #broken = true;
    homepage = "https://memory.foonathan.net/";
    description = "STL compatible C++ memory allocator library using a new RawAllocator concept that is similar to an Allocator but easier to use and write.";
    license = licenses.zlib;
    platforms = platforms.linux;
  };
}
