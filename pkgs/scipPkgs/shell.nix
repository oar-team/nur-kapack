{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    alejandra
    just
    nvfetcher
    deadnix
    statix
  ];
}
