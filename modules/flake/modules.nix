{
  flake.nixosModules = {
    batsky = ../nixos/batsky.nix;
    bs-slurm = ../nixos/bs-slurm.nix;
    fe-slurm = ../nixos/fe-slurm.nix;
    rs-munge = ../nixos/bs-munge.nix;
    oar = ../nixos/oar.nix;
    cigri = ../nixos/cigri.nix;
    # colmet = ../nixos/colmet.nix;
    my-startup = ../nixos/my-startup.nix;
    phpfpm0 = ../nixos/phpfpm0.nix;
    ear = ../nixos/ear.nix;
  };
}
