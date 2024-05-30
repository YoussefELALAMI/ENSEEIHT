(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
(*
          ⊤
        /   \
    pair     impair
        \ | /
          ⊥
*)
(* type t = Bottom | Top | Pair | Impair *)
(* ou type t = bool * bool 
   => Présence de valeur pair * Présence de valeur impair   
*)
type t = bool * bool

(* a printing function (useful for debuging), 
let fprint ff = function
  | Bottom -> Format.fprintf ff "⊥"
  | Top -> Format.fprintf ff "⊤"
  | Pair -> Format.fprintf ff "pair"
  | Impair -> Format.fprintf ff "impair"
*)
let fprint ff = function
  | (true, true) -> Format.fprintf ff "⊤"
  | (true, false) -> Format.fprintf ff "pair"
  | (false, true) -> Format.fprintf ff "impair"
  | (false, false) -> Format.fprintf ff "⊥"

(* the order of the lattice. *)
(*let order x y = match x, y with
  | Bottom, _ -> true
  | _, Top -> true
  | _, _ -> x = y*)

let order (p1, i1) (p2, i2) = 
  (p1 <= p2) && (i1 <= i2)

(* and infimums of the lattice. *)
let top = (true, true)
let bottom = (false, false)

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

let join (p1, i1) (p2, i2) =
  (p1 || p2, i1 || i2)

let meet (p1, i1) (p2, i2) = 
  (p1 && p2, i1 && i2)

let widening = join  (* Ok, maybe you'll need to implement this one if your
                      * lattice has infinite ascending chains and you want
                      * your analyses to terminate. *)

let sem_itv n1 n2 =
  if n1 < n2 then (* si n1 < n2 alors on prend tout l'ensemble *)
    top
  else if n1 > n2 then (* si n1 > n2 alors on prend l'ensemble vide *)
    bottom
  else (* n1 = n2 *)
    let p1 = n1 mod 2 = 0 in
    (p1, not p1)

let sem_plus x y = match x, y with
  | (true, true), _ 
  | _, (true, true) -> top
  | (false, false), _ 
  | _, (false, false) -> bottom
  | (p1, i1), (p2, i2) -> ((p1 && p2) || (i2 && i1), (p1 = i2) || (p2 = i1))

let sem_minus x y = match x, y with
  | (true, true), _
  | _, (true, true) -> top
  | (false, false), _
  | _, (false, false) -> bottom
  | (p1, i1), (p2, i2) -> 
    ((p1 && i2) || (i1 && p2), (p1 = i2) || (p2 = i1))
let sem_times x y = match x, y with
  | (true, true), _
  | _, (true, true) -> top
  | (false, false), _
  | _, (false, false) -> bottom
  | (p1, i1), (p2, i2) -> (p1 && p2, i1 && i2)
let sem_div x y = match x, y with
  | (false, false), _
  | _, (false, false) -> bottom
  | _, _ -> top
let sem_guard = function
  | t -> t

let backsem_plus x y r = x, y
let backsem_minus x y r = x, y
let backsem_times x y r = x, y
let backsem_div x y r = x, y
