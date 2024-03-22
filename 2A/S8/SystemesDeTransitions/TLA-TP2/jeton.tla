---------------- MODULE jeton ----------------
\* Time-stamp: <07 mar 2013 15:49 queinnec@enseeiht.fr>

(* Algorithme d'exclusion mutuelle à base de jeton. *)

EXTENDS Naturals, FiniteSets

CONSTANT N

ASSUME N \in Nat /\ N > 1

Processus == 0..N-1

Hungry == "H"
Thinking == "T"
Eating == "E"

VARIABLES
  etat,
  jeton,
  canal

TypeInvariant ==
   [] (/\ etat \in [ Processus -> {Hungry,Thinking,Eating} ]
       /\ jeton \in [ Processus -> BOOLEAN ]
       /\ canal \in [ Processus ->  BOOLEAN ])

ExclMutuelle == [] (\A i,j \in Processus : etat[i] = Eating /\ etat[j] = Eating => i=j)

VivaciteIndividuelle == \A i \in Processus : etat[i] = Hungry ~> etat[i] = Eating

VivaciteGlobale == (\E i \in Processus : etat[i] = Hungry) ~> (\E j \in Processus : etat[j] = Eating)

(*JetonTourne == \A i \in Processus : jeton = i ~> jeton = (i+1)%N*)
JetonTourne == \A i \in Processus : jeton[i] ~> jeton[(i+1)%N]

JetonVaPartout == \A i \in Processus : []<>(jeton[i])

JetonExistanceUnicite == [](Cardinality(\A i \in Processus : jeton[i]) = 1)

(*Sanity ==
  [] (\A i \in Processus : etat[i] = Eating => jeton = i)*)
Sanity ==
  [] (\A i \in Processus : etat[i] = Eating => jeton[i])
----------------------------------------------------------------

Init ==
 /\ etat = [ i \in Processus |-> Thinking ]
 /\ \E j \in Processus : jeton  = [ i \in Processus |-> i = j ]

demander(i) ==
  /\ etat[i] = Thinking
  /\ etat' = [ etat EXCEPT ![i] = Hungry ]
  /\ UNCHANGED jeton

entrer(i) ==
  /\ etat[i] = Hungry
  /\ jeton[i]
  /\ etat' = [ etat EXCEPT ![i] = Eating ]
  /\ UNCHANGED jeton

sortir(i) ==
  /\ etat[i] = Eating
  /\ etat' = [ etat EXCEPT ![i] = Thinking ]
  /\ UNCHANGED jeton
  (*/\ jeton' = (i+1)%N*)

bouger(i) ==
  /\ jeton[i]
  /\ etat[i] # Eating
  (*/\ etat[i] = Thinking*)
  (*/\ jeton' = (i+1)%N*)
  /\ jeton' = [ jeton EXCEPT ![i] = FALSE, ![(i+1) % N] = TRUE ]
  /\ UNCHANGED etat

Next ==
 \E i \in Processus :
    \/ demander(i)
    \/ entrer(i)
    \/ sortir(i)
    \/ bouger(i)

Fairness == \A i \in Processus :
              /\ SF_<<etat,jeton>> (entrer(i))
              /\ WF_<<etat,jeton>> (sortir(i))
              /\ SF_<<etat,jeton>> (bouger(i))

Spec ==
 /\ Init
 /\ [] [ Next ]_<<etat,jeton>>
 /\ Fairness

================
