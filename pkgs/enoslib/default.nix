{ python3Packages, fetchgit, execo, ansible, ring, iotlabsshcli }:
let
  distem = python3Packages.buildPythonPackage rec {
    pname = "distem";
    version = "0.0.5";
    src = fetchgit {
      url = "https://gitlab.inria.fr/myriads-team/python-distem";
      rev = "650931b377c35470e3c72923f9af2fd9c37f0470";
      sha256 = "sha256-brrs350eC+vBzLJmdqw4FnjNbL+NgAfnqWDjsMiEyZ4=";
    };
    propagatedBuildInputs = [
      python3Packages.requests
    ];
  };

  python-grid5000 = python3Packages.buildPythonPackage rec {
    pname = "python-grid5000";
    version = "1.2.4";
    src = fetchgit {
      url = "https://gitlab.inria.fr/msimonin/python-grid5000";
      rev = "v${version}";
      sha256 = "sha256-wfDyoaOn0Dlbz/metxskbN4frsJbkEe8byUeO01upV8=";
    };
    doCheck = false;
    propagatedBuildInputs = [
      python3Packages.pyyaml
      python3Packages.requests
      python3Packages.ipython
    ];
  };
in
python3Packages.buildPythonPackage rec {
  pname = "enoslib";
  version = "v8.1.3";
  src = fetchgit {
    url = "https://gitlab.inria.fr/discovery/enoslib";
    rev = "${version}";
    sha256 = "sha256-fV2lpNYJqvLOkpOKNBXMdlBC288SAH2xPx42dkqfSzU=";
  };
  # We do the following because nix cannot yet access the extra builds of poetry
  patchPhase = ''
    substituteInPlace setup.cfg --replace "rich[jupyter]~=12.0.0" "rich>=12.0.0"
  '';
  propagatedBuildInputs = [
    python3Packages.cryptography
    python3Packages.ansible
    python3Packages.sshtunnel
    python3Packages.python-vagrant
    python3Packages.ipywidgets
    python3Packages.rich
    python3Packages.jsonschema

    ansible

    distem
    iotlabsshcli
    ring
    execo
    python-grid5000
  ];
  doCheck = false;
  # checkInputs = [
  #   python3Packages.pytest
  #   python3Packages.ansible
  #   ansible
  # ];
}
