(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)

 (*
            ⊤
          / | \
    ...-1   0   1 ...
          \ | /
            ⊥
    *)
type t =
  | Top
  | Bottom
  | Cst of int

(* a printing function (useful for debuging), *)
let fprint ff = function
  | Top -> Format.fprintf ff "⊤"
  | Bottom -> Format.fprintf ff "⊥"
  | Cst i -> Format.fprintf ff "%d" i

(* the order of the lattice. *)
let order x y = match x, y with
  |Bottom, _ -> true
  | _, Top -> true
  | Cst i, Cst j -> i = j
  | _, _ -> false

(* and infimums of the lattice. *)
let top = Top

let bottom = Bottom

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

(* La fonction join c'est l'union des deux ensembles,
  * Top est l'ensemble de tous les entiers, Bottom est l'ensemble vide.
  * Union d'un ensemble Top at de n'importe quel autre ensemble est Top.
  * Si on a un entier i et un entier j, on retourne l'entier i si i = j, sinon on retourne l'ensemble Top.
*)
  let join x y = match x, y with
  | Bottom, _ -> y
  | _, Bottom -> x
  | Top, _ -> Top
  | _, Top -> Top
  | Cst i, Cst j -> if i = j then Cst i else Top

(* La fonction meet c'est l'intersection des deux ensembles, 
 * Top est l'ensemble de tous les entiers, Bottom est l'ensemble vide.
  * Intersection d'un ensemble Bottom (ensemble vide) et de n'importe quel autre ensemble est Bottom.
 * Si on a un entier i et un entier j, on retourne l'entier i si i = j, sinon on retourne l'ensemble vide.
*)

let meet x y = match x, y with
  | Bottom, _ -> Bottom
  | _, Bottom -> Bottom
  | Top, _ -> y
  | _, Top -> x
  | Cst i, Cst j -> if i = j then Cst i else Bottom

let widening = join  (* Ok, maybe you'll need to implement this one if your
                      * lattice has infinite ascending chains and you want
                      * your analyses to terminate. *)

(* Opérateurs Arithmetique: *)

(* Fonction sem_itv :
 * Représenter toutes les valeurs (intervalle) entre n1 et n2.
*)
let sem_itv n1 n2 =
  if n1 = n2 then Cst n1
  else if n1 < n2 then top
  else bottom

(* Fonction sem_plus :
 * Bottom + n = Bottom : Bottom absorbe tout, parce que rien plus un nombre est toujours rien.
 * Top + n = Top : Top absorbe tout, parce que un nombre plus un nombre est toujours un nombre.
*)
let sem_plus x y =
  match x, y with
  | Cst i, Cst j -> Cst (i + j)
  | Bottom, _
  | _, Bottom -> Bottom
  | Top, _
  | _, Top -> Top

let sem_minus x y =
  match x, y with
  | Cst i, Cst j -> Cst (i - j)
  | Bottom, _
  | _, Bottom -> Bottom
  | Top, _
  | _, Top -> Top

let sem_times x y =
  match x, y with
  | Cst i, Cst j -> Cst (i * j)
  | Top, Cst 0
  | Cst 0, Top -> Cst 0
  | Bottom, _
  | _, Bottom -> Bottom
  | Top, _
  | _, Top -> Top

let sem_div x y = 
  match x, y with
  | Cst i, Cst j -> if j = 0 then Bottom else Cst (i / j)
  | Bottom, _
  | _, Bottom -> Bottom
  | Top, _
  | _, Top -> Top

let sem_guard t = 
  (* t ∩ ]0, +∞[ *)
  match t with
  | Cst i -> if i > 0 then t else Bottom
  | Bottom -> Bottom
  | Top -> Top

(* Implémentation des sémantiques arrières*)
let backsem_plus x y r = x, y
let backsem_minus x y r = x, y
let backsem_times x y r = x, y
let backsem_div x y r = x, y
