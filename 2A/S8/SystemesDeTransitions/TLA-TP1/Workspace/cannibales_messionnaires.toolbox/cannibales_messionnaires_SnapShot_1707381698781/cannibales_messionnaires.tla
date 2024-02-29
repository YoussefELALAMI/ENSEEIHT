---------------------- MODULE cannibales_messionnaires ----------------------

(* Le problème des missionnaires et des cannibales*)
(* Version ensembliste basique *)

EXTENDS Naturals, FiniteSets

EntitesC == {"C1", "C2", "C3"}

EntitesM == {"M1", "M2", "M3"}

Entites == EntitesC \union EntitesM

Barque == {"G", "D"}

VARIABLES
  riveG, riveD, barque

TypeInvariant ==
  [] (/\ riveG \subseteq Entites
      /\ riveD \subseteq Entites
      /\ riveG \intersect riveD = {}
      /\ riveG \union riveD = Entites)

pasMiam1(rive) == 
    /\ ((EntitesC \intersect rive) /= {}) => ((Cardinality(EntitesC \intersect rive) \geq  Cardinality(EntitesM \intersect rive)))

pasMiam ==
  pasMiam1(riveG) /\ pasMiam1(riveD)

ToujoursOk == []pasMiam

Solution ==
  [] \neg(riveD = Entites)
----------------------------------------------------------------

Init ==
  /\ riveG = Entites
  /\ riveD = {}
  /\ barque = "G"

bougeGD(S) ==
  /\ S \subseteq riveG
  /\ barque = "G"
  /\ Cardinality(S) \leq 2
  /\ riveG' = riveG \ S
  /\ riveD' = riveD \union S
  /\ barque' = "D"
  /\ pasMiam'

bougeDG(S) ==
  /\ S \subseteq riveD
  /\ barque = "D"
  /\ Cardinality(S) \leq 2
  /\ riveD' = riveD \ S
  /\ riveG' = riveG \union S
  /\ barque' = "G"
  /\ pasMiam'

Next == \E s \in SUBSET Entites :
          bougeGD(s) \/ bougeDG(s)
        

Spec == Init /\ [] [ Next ]_<<riveG,riveD, barque>>

=============================================================================
\* Modification History
\* Last modified Thu Feb 08 09:41:34 CET 2024 by yelalami
\* Created Thu Feb 08 08:37:05 CET 2024 by yelalami