---------------- MODULE philosophes0 ----------------
(* Philosophes. Version en utilisant l'état des voisins. *)

EXTENDS Naturals

CONSTANT N

Philos == 0..N-1

gauche(i) == (i+1)%N       \* philosophe à gauche du philo n°i
droite(i) == (i+N-1)%N     \* philosophe à droite du philo n°i
fourchetteDroite(i) == (i-1)%N   \* fourchette à droite du philo n°i
fourchetteGauche(i) == (i)%N     \* fourchette à gauche du philo n°i

Hungry == "H"
Thinking == "T"
Eating == "E"
Libre == "L"
AssietteGauche == "AG"
AssietteDroite == "AD"

VARIABLES
    etat,         \* i -> Hungry,Thinking,Eating
    etatFourchette      \* j -> Used, NotUsed

TypeInvariant == [](etat \in [ Philos -> { Hungry, Thinking, Eating }]
                    /\ etatFourchette \in [ Philos -> { Libre, AssietteGauche, AssietteDroite }])

(* TODO : autres propriétés de philosophes0 (exclusion, vivacité) *)
VoisinDroite == [](\A i \in Philos : etat[i] = Eating => etat[droite(i)] /= Eating) 

VoisinGauche == [](\A i \in Philos : etat[i] = Eating => etat[gauche(i)] /= Eating) 

FourchetteDroiteLibre == [](\A i \in Philos : etat[i] = Eating => etatFourchette[fourchetteDroite(i)] = AssietteDroite )

FourchetteGaucheLibre == [](\A i \in Philos : etat[i] = Eating => etatFourchette[fourchetteGauche(i)] = AssietteGauche )

VivaciteIndividuelle == \A i \in Philos : etat[i] = Hungry ~> etat[i] = Eating

VivaciteGlobale == (\E i \in Philos : etat[i] = Hungry) ~> (\E j \in Philos : etat[j] = Eating )

----------------------------------------------------------------

Init == 
 /\ etat = [ i \in Philos |-> Thinking ]
 /\ etatFourchette  = [ i \in Philos |-> Libre ]

demande(i) == 
  /\ etat[i] = Thinking
  /\ etat' = [ etat EXCEPT ![i] = Hungry ]
  /\ UNCHANGED etatFourchette
  
utiliserFouchetteDroite(i) ==
    /\ etatFourchette[fourchetteDroite(i)] = Libre
    /\ etatFourchette' = [ etat EXCEPT ![fourchetteDroite(i)] = AssietteDroite ]
    /\ UNCHANGED etat
    
utiliserFouchetteGauche(i) ==
    /\ etatFourchette[fourchetteGauche(i)] = Libre
    /\ etatFourchette' = [ etat EXCEPT ![fourchetteGauche(i)] = AssietteGauche ]
    /\ UNCHANGED etat

mange(i) == 
  /\ etat[i] = Hungry /\ etat[gauche(i)] /= Eating /\ etat[droite(i)] /= Eating
  /\ etatFourchette[fourchetteDroite(i)] = AssietteDroite
  /\ etatFourchette[fourchetteGauche(i)] = AssietteGauche
  /\ etat' = [ etat EXCEPT ![i] = Eating ]
  /\ UNCHANGED etatFourchette
  
pense(i) == 
  /\ etat[i] = Eating
  /\ etat' = [ etat EXCEPT ![i] = Thinking ]
    /\ etatFourchette[gauche(i)] = AssietteGauche /\  etatFourchette[droite(i)] = AssietteDroite
    /\ etatFourchette' = [ etat EXCEPT ![gauche(i)] = Libre ]
    /\ etatFourchette' = [ etat EXCEPT ![droite(i)] = Libre ]

Next ==
  \E i \in Philos : \/ demande(i)
                    \/ utiliserFouchetteDroite(i)
                    \/ utiliserFouchetteGauche(i)
                    \/ mange(i)
                    \/ pense(i)

Fairness == \A i \in Philos :
              /\ WF_<<etat,etatFourchette>> (pense(i))
              /\ SF_<<etat,etatFourchette>> (mange(i))

Spec ==
  /\ Init
  /\ [] [ Next ]_<<etat,etatFourchette>>
  /\ Fairness

================================
