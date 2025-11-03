{
  outputs = inputs: inputs.autopilot.lib.mkFlake
    {
      inherit inputs;
      autopilot = {
        parts.path = ./modules/flake;
        nixpkgs.config.allowUnfree = true;
        lib = {
          path = ./lib;
          extender = inputs.nixpkgs.lib;
          extensions = with inputs; [ autopilot.lib parts.lib ];
        };
      };
    }
    { systems = import inputs.systems; };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.parts.url = "github:hercules-ci/flake-parts";
  inputs.parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  inputs.systems.url = "github:nix-systems/default";
  inputs.autopilot.url = "github:stepbrobd/autopilot";
  inputs.autopilot.inputs.nixpkgs.follows = "nixpkgs";
  inputs.autopilot.inputs.parts.follows = "parts";
  inputs.autopilot.inputs.systems.follows = "systems";
}
