{ stdenv , lib, fetchurl, buildPackages, perl }:

stdenv.mkDerivation rec {
  pname = "openssl-${version}";
  version = "1.0.2r";
  
  src = fetchurl {
    url = "https://www.openssl.org/source/${pname}.tar.gz";
    sha256 = "1mnh27zf6r1bhm5d9fxqq9slv2gz0d9z2ij9i679b0wapa5x0ldf";
  };
  
  patches = [ ./nix-ssl-cert-file.patch ];
  
  postPatch = ''
      patchShebangs Configure

      patchShebangs test/*
      for a in test/t* ; do
        substituteInPlace "$a" \
          --replace /bin/rm rm
      done
  ''; 

  outputs = [ "bin" "dev" "out" "man" ];
  setOutputFlags = false;
  separateDebugInfo = stdenv.hostPlatform.isLinux;
  
  nativeBuildInputs = [ perl ];
  
  configureFlags = [
    "shared" # "shared" builds both shared and static libraries
    "--libdir=lib"
    "--openssldir=etc/ssl"
  ];
  
  configureScript = "./Configure linux-generic${toString stdenv.hostPlatform.parsed.cpu.bits}";

  makeFlags = [ "MANDIR=$(man)/share/man" ];
  
  enableParallelBuilding = true;

  postInstall = ''
    # If we're building dynamic libraries, then don't install static
    # libraries.
    if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
      rm "$out/lib/"*.a
    fi  
    mkdir -p $bin
    mv $out/bin $bin/
    mkdir $dev
    mv $out/include $dev/
    # remove dependency on Perl at runtime
    rm -r $out/etc/ssl/misc
    rmdir $out/etc/ssl/{certs,private}
  '';

  postFixup = ''
     # Check to make sure the main output doesn't depend on perl
     if grep -r '${buildPackages.perl}' $out; then
       echo "Found an erroneous dependency on perl ^^^" >&2
       exit 1
     fi
  '';
  
  meta = with lib; {
    homepage = https://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    license = licenses.openssl;
    platforms = platforms.all;
  };
}
