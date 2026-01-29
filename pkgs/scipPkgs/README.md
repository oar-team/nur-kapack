# scipopt-nix

[![GitHub License](https://img.shields.io/github/license/Lichthagel/scipopt-nix?style=flat-square)](./LICENSE)
[![GitHub top language](https://img.shields.io/github/languages/top/Lichthagel/scipopt-nix?style=flat-square)](https://github.com/search?q=repo%3ALichthagel%2Fscipopt-nix++language%3ANix&type=code)
[![built with garnix](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2FLichthagel%2Fscipopt-nix&style=flat-square)](https://garnix.io)

Nix flake and expressions for tools from the SCIP Optimization Suite.

## Packages

The following packages are provided: scip, gcg, soplex, papilo, zimpl, pysoplex, pyscipopt, pygcgopt, scippp, mumps, ipopt-mumps, ug, mip-dd, vipr.

## Usage

When using flakes, add

```nix
scipopt-nix = {
  url = "github:Lichthagel/scipopt-nix";
  # or "gitlab:jgatzweiler/scipopt-nix?host=git.or.rwth-aachen.de"
  inputs.nixpkgs.follows = "nixpkgs";
};
```

to your inputs.

### Binary cache

`scipopt-nix` uses Garnix CI. To access its binary cache see [here](https://garnix.io/docs/caching).

## Templates

This repository contains some templates to get you started.

| name      | description                                       |
| --------- | ------------------------------------------------- |
| scip      | An optimization project using SCIP in C (or C++)  |
| gcg       | An optimization project using GCG in C (or C++)   |
| pyscipopt | An optimization project using PySCIPOpt in Python |
| pygcgopt  | An optimization project using PyGCGOpt in Python  |

To use a template, run

```sh
nix flake init -t "github:Lichthagel/scipopt-nix#<template>"
```

where `<template>` is one of the names in the table above.

## Working on SCIP/GCG

If you are working on a local copy or fork of SCIP/GCG you may want to use something like this:

```nix
{
  description = "SCIP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    scipopt-nix = {
      url = "github:Lichthagel/scipopt-nix";
      # url = "gitlab:jgatzweiler/scipopt-nix?host=git.or.rwth-aachen.de";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      scipopt-nix,
    }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            selfPkgs = self.packages.${system};
            scipoptPkgs = scipopt-nix.packages."${system}";
          }
        );
    in
    {
      packages = eachSystems (
        { scipoptPkgs, ... }:
        {
          default = scipoptPkgs.scip.overrideAttrs (oldAttrs: {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.difference ./. ./build;
            }; # contrary to `./.` this allows having `./build` in the working tree when using `path:.`
          });
        }
      );

      devShells = eachSystems (
        { pkgs, selfPkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "scip-dev";

            packages = with pkgs; [
              gdb
              ninja
              clang
              cppcheck
              valgrind
            ];

            inputsFrom = [ selfPkgs.default ];
          };
        }
      );
    };
}

```

If you do not want to track `flake.nix` with git, you can use `nix develop/run path:.` and add `flake.nix` and `flake.lock` to `.git/info/exclude`.
