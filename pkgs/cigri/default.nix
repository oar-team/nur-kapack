{ stdenv, lib, pkgs, fetchgit, bundlerEnv, ruby, bash, perl }:
let
  rubyEnv = bundlerEnv rec {
    name = "cigri-env";
    inherit ruby;
    gemdir = ./.;
    #groups = [ "default" "unicorn" "test" ]; # TODO not used
  };
in
stdenv.mkDerivation rec {
  name = "cigri-3.0.0";

  src = fetchgit {
    url = "https://gitlab.inria.fr/cigri-ctrl/feedforward-approach/cigri-src.git";
    rev = "b90ad8c43656bc316d12b55b976e642fe6bd0fca";
    sha256 = "sha256-CFXtoGxyhLztPr8hqLXsrZCGp1uPBIdUsVpLE0nCELk=";
  };

  buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler bash perl ];

  buildPhase = ''
    # TODO warning /var/cigri/state can be overriden /modules/services/cigri.nix configuration 
    substituteInPlace modules/almighty.rb \
    --replace /var/run/cigri/almighty.pid /var/cigri/state/home/pidsalmighty.pid

    mkdir -p $out/bin  $out/sbin
    make PREFIX=$out SHELL=${bash}/bin/bash \
    install-cigri-libs install-cigri-modules \
    install-cigri-server-tools install-cigri-user-cmds \
    install-cigri-api
    # generate well located newcluster
    echo -e "#!/bin/bash\nCIGRICONFFILE=/etc/cigri.conf CIGRIDIR=$out/share/cigri \
    $out/share/cigri/sbin/newcluster "'"$@"' > $out/sbin/newcluster
    chmod 755 $out/sbin/newcluster
  '';

  postInstall = ''
    cp -r database $out
  '';

  # Allow rubyEnv to be use in modules/services/cigri configuration
  passthru = {
    inherit rubyEnv;
  };

  meta = with lib; {
    homepage = "https://github.com/oar-team/cigri";
    description = "CiGri: a Lightweight Grid Middleware";
    license = licenses.lgpl3;
    longDescription = ''
    '';
  };
}
