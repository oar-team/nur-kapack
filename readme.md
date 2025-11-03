# Kapack

Kapack contains [Nix](https://nixos.org/) package definitions of the software we
work on at the [DataMove](https://team.inria.fr/datamove/) team: OAR, Batsim
ecosystem, Melissa, etc.

## Interactive usage

You can enter shells that contain some of our packages with `nix run`.

```shell
nix shell github:stepbrobd/kapack#{batexpe,batsched,batsim,pybatsim}
```

## Usage from Nix expressions

You can write Nix expression to define environments that use our packages.

```nix
{
  inputs.kapack.url = "github:stepbrobd/kapack";
  outputs = inputs:
    let
      inherit (inputs.kapack.inputs) nixpkgs;
      inherit (nixpkgs) lib;
    in
    {
      devShells = lib.genAttrs lib.systems.flakeExposed (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              batexpe
              batsched
              batsim
              pybatsim
            ];
          };
        }
      );
    };
}
```

If you want to pin the Kapack version you use, you can do one of the following:

- Pin to a specific commit:
  `inputs.kapack.url = "github:stepbrobd/kapack/019d3bebf1e090c8d9ad1bd0cc3ad03ee8b4335d";`
- Pint to a named branch: `inputs.kapack.url = "github:stepbrobd/kapack/25.05";`

## Adding new packages and modules

Kapack uses [flake-parts](https://flake.parts/) to split Nix Flake definitions
into more manageable flake modules, and are automatically loaded after checking
into VCS.

The general evaluation order for everything inside Kapack:

- `autopilot` kicks in and instantiates its own helper functions
- Load helper functions in `lib`
- Load flake modules under `modules/flake`
- Definitions in `modules/flake`
  - Loads `pkgs` based on directory structure and expose them to flake output
    `packages.${system}.<name>`
  - Loads `modules/nixos` based on directory structure and expose them to flake
    output `nixosModules.<name>`

For example:

```txt
- modules/nixos
  - batsky.nix
  - oar/default.nix
- pkgs
  - batsim/default.nix
  - batsim-master.nix
```

Would expose

```txt
- nixosModules.batsky
- nixosModules.oar
- pkgs.batsim
- pkgs.batsim-master
```

Packages defined in `pkgs` are automatically added to the `callPackage`
argument, thus internal dependencies would work right out of the box.

New packages can be added by

- creating a directory under `pkgs` with a file named `default.nix` where its
  content would be evaluated as a derivation, or an attribute set for
  sub-namespaces
- creating a file (discouraged) under `pkgs` And check the files into VCS.

The same principle also applies to NixOS modules.
