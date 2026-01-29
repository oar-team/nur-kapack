{pkgs, ...}: rec {
  gcg = pkgs.callPackage ./gcg.nix {inherit scip;};
  ipopt-mumps = pkgs.callPackage ./ipopt-mumps.nix {};
  mip-dd = pkgs.callPackage ./mip-dd.nix {inherit scip;};
  mumps = pkgs.callPackage ./mumps.nix {};
  papilo = pkgs.callPackage ./papilo.nix {inherit soplex;};
  pygcgopt = pkgs.python3Packages.callPackage ./pygcgopt.nix {inherit scip gcg pyscipopt;};
  pyscipopt = pkgs.python3Packages.callPackage ./pyscipopt.nix {inherit scip;};
  pysoplex = pkgs.python3Packages.callPackage ./pysoplex.nix {};
  scip = pkgs.callPackage ./scip.nix {inherit soplex papilo zimpl ipopt-mumps;};
  scippp = pkgs.callPackage ./scippp.nix {inherit scip;};
  soplex = pkgs.callPackage ./soplex.nix {};
  ug = pkgs.callPackage ./ug.nix {inherit scip;};
  zimpl = pkgs.callPackage ./zimpl.nix {};
  vipr = pkgs.callPackage ./vipr.nix {};

  default = scip;
}
