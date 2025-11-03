{
  perSystem = { lib, pkgs, ... }: {
    formatter = pkgs.writeShellScriptBin "formatter" ''
      ${lib.getExe pkgs.nixpkgs-fmt} .
    '';
  };
}
