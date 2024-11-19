{ lib
, dyn_rm-dynres
, writers
, pypmix-dynres   
}:

writers.writePython3Bin "prrte_expansion_test" {
      # Need to fix  prrte_expansion_test.py
      flakeIgnore = [
        #"E225" "E226" "E501" "W291" "W292" "W293" "F405"
        "E127" "E203" "E222" "E225" "E226" "E231" "E251" "E261" "E271" "E711"
        "E302" "E303" "F401" "F403" "F405" "E501" "W291" "W292" "W293"
      ];
      libraries = [
        dyn_rm-dynres
        pypmix-dynres
      ];
    } (lib.fileContents "${dyn_rm-dynres.src}/dyn_rm/tests/prrte_expansion_test.py")
