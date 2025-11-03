{ lib, inputs, ... }:

let
  inherit (lib) importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }: {
    packages = (mkDynamicAttrs {
      dir = ../../pkgs;
      fun = name: importPackagesWith (pkgs // { inherit inputs lib; }) (../../pkgs/. + "/${name}") { };
    });
  };
}
