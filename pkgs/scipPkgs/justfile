build PACKAGE:
  nix build -vL .\#{{PACKAGE}}

run PACKAGE:
  nix run -vL .\#{{PACKAGE}}

update:
  nix flake update
  nvfetcher

format:
  alejandra . -e ./_sources

check:
  nix flake check