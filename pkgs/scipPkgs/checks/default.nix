{
  self,
  nixpkgs,
  system,
  pkgs,
  ...
}: let
  inherit (nixpkgs) lib;

  nix-files = let
    fs = lib.fileset;
  in
    fs.toSource rec {
      root = ./..;
      fileset = fs.difference (fs.fileFilter (file: file.hasExt "nix") root) (root + /_sources);
    };

  # runs a single command as a check
  mkBasicCheck = {
    name,
    command,
  }:
    pkgs.stdenvNoCC.mkDerivation {
      name = "check-${name}";

      dontUnpack = true;
      doCheck = true;

      checkPhase = ''
        runHook preCheck

        ${command}

        runHook postCheck
      '';

      installPhase = ''
        mkdir -p $out
      '';
    };

  # like builtins.getFlake but using our own inputs
  getFlake = path: let
    flake = (import path).outputs {
      self = flake;
      inherit nixpkgs;
      scipopt-nix = self;
    };
  in
    flake;
in {
  alejandra = mkBasicCheck {
    name = "alejandra";
    command = "${pkgs.alejandra}/bin/alejandra -c ${nix-files}";
  };

  deadnix = mkBasicCheck {
    name = "deadnix";
    command = "${pkgs.deadnix}/bin/deadnix -f ${nix-files}";
  };

  statix = mkBasicCheck {
    name = "statix";
    command = "${pkgs.statix}/bin/statix check ${nix-files}";
  };

  template-scip = let
    pkg = (getFlake ../templates/scip/flake.nix).packages.${system}.default;
  in
    mkBasicCheck {
      name = "template-scip";
      command = "${pkg}/bin/${pkg.name}";
    };

  template-gcg = let
    pkg = (getFlake ../templates/gcg/flake.nix).packages.${system}.default;
  in
    mkBasicCheck {
      name = "template-gcg";
      command = "${pkg}/bin/${pkg.name}";
    };

  template-pyscipopt = let
    devShell = (getFlake ../templates/pyscipopt/flake.nix).devShells.${system}.default;
  in
    devShell.overrideAttrs (oldAttrs: {
      phases = oldAttrs.phases ++ ["checkPhase"];

      doCheck = true;

      postCheck = ''
        LC_ALL=en_US.UTF-8 python ${../templates/pyscipopt}/main.py
      '';
    });

  template-pygcgopt = let
    devShell = (getFlake ../templates/pygcgopt/flake.nix).devShells.${system}.default;
  in
    devShell.overrideAttrs (oldAttrs: {
      phases = oldAttrs.phases ++ ["checkPhase"];

      doCheck = true;

      postCheck = ''
        LC_ALL=en_US.UTF-8 python ${../templates/pygcgopt}/main.py
      '';
    });
}
