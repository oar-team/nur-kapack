final: prev:

let

  isReserved = n: n == "lib" || n == "overlays" || n == "modules" || n == "pkgs";
  nameValuePair = n: v: { name = n; value = v; };
  nurAttrs = import ./../nur.nix { pkgs = prev; };

in

  builtins.listToAttrs
  (map (n: nameValuePair n nurAttrs.${n})
  (builtins.filter (n: !isReserved n)
  (builtins.attrNames nurAttrs)))
