{ pkgs }:
#pkgs.haskellPackages // {
{
  # Add Haskell packages here
  arion-compose = pkgs.haskellPackages.callPackage ./arion-compose.nix { };
}
