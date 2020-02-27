{ gmp6 }:

gmp6.overrideAttrs (attr: rec {
  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    cat <<EOF >>$dev/lib/pkgconfig/gmp.pc
Name: gmp
Description: A free library for arbitrary precision arithmetic.
Version: 6.2.0
Libs: -L$out/lib -lgmp
Cflags: -I$dev/include
EOF
   cat <<EOF >>$dev/lib/pkgconfig/gmpxx.pc
Name: gmpxx
Description: A free library for arbitrary precision arithmetic.
Version: 6.2.0
Requires: gmp
Libs: -L$out/lib -lgmpxx
Cflags: -I$dev/include
EOF
  '';
})
