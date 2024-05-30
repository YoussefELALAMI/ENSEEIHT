(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
type t = Bot | Itv of int option * int option

(* a printing function (useful for debuging), *)
let fprint ff = function
  | Bot -> Format.fprintf ff "⊥"
  | Itv (Some n1, Some n2) -> Format.fprintf ff "[%d, %d]" n1 n2
  | Itv (Some n1, None) -> Format.fprintf ff "[%d, +∞[" n1
  | Itv (None, Some n2) -> Format.fprintf ff "]-∞, %d]" n2
  | Itv (None, None) -> Format.fprintf ff "]-∞, +∞["

(* Extension de <= `a Z U {-oo}. *)
let leq_minf x y = match x, y with
  | None, _ -> true (* -oo <= y *)
  | _, None -> false (* x > -oo (x != -oo) *)
  | Some x, Some y -> x <= y

(* Extension de <= `a Z U {+oo}. *)
let leq_pinf x y = match x, y with
  | _, None -> true (* x <= +oo *)
  | None, _ -> false (* +oo > y (y != +oo) *)
  | Some x, Some y -> x <= y

(* La petite fonction suivante pour maintenir l’invariant de type n1 ≤ n2 lorsqu’on crée des intervalles *)
let mk_itv o1 o2 = match o1, o2 with
  | None, _ 
  | _, None -> Itv (o1, o2)
  | Some n1, Some n2 -> if n1 > n2 then Bot else Itv (o1, o2)

(* the order of the lattice. *)
let order x y = match x, y with
  | Bot, _ -> true
  | _, Bot -> false
  | Itv (n1, n2), Itv (m1, m2) -> leq_minf m1 n1 && leq_pinf n2 m2


(* and infimums of the lattice. *)
let top = Itv (None, None)
let bottom = Bot

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

let join x y = match x, y with
  | Bot, _ -> y
  | _, Bot -> x
  | Itv (n1, n2), Itv (m1, m2) -> mk_itv (if leq_minf n1 m1 then n1 else m1) (if leq_pinf n2 m2 then m2 else n2)

let meet x y = match x, y with
  | Bot, _
  | _, Bot -> Bot
  | Itv (n1, n2), Itv (m1, m2) -> mk_itv (if leq_minf n1 m1 then m1 else n1) (if leq_pinf n2 m2 then n2 else m2)


(* implémentation d'élargissement *)
let widening x y = 
  match x, y with
  | Bot, _ -> y
  | _, Bot -> x
  | Itv (a, b), Itv (c, d) -> 
    mk_itv (if leq_minf a c then a else None) (if leq_pinf d b then b else None)

let sem_itv n1 n2 =
  if n1 <= n2 then Itv (Some n1, Some n2)
  else Bot

let sem_plus x y =
  match x, y with
  | Bot, _
  | _, Bot -> Bot
  | Itv (n1, n2), Itv (m1, m2) -> mk_itv (match n1, m1 with
    | None, _
    | _, None -> None
    | Some n1, Some m1 -> Some (n1 + m1)) (match n2, m2 with
    | None, _
    | _, None -> None
    | Some n2, Some m2 -> Some (n2 + m2))

let neg_inf x = match x with
  | None -> None
  | Some a -> Some(- a)

let sem_neg x = match x with
  | Bot -> Bot
  | Itv (a, b) -> Itv (neg_inf b, neg_inf a)

let sem_minus x y =
  sem_plus x (sem_neg y)

(*produit cartésien*)
let prod a b = 
  match a, b with
  | None, _
  | _, None -> None
  | Some a, Some b -> Some (a * b)

let min_option a b = match a, b with
  | None, _
  | _, None -> None
  | Some a, Some b -> Some (min a b)

let max_option a b = match a, b with
  | None, _
  | _, None -> None
  | Some a, Some b -> Some (max a b)

(* [a,b]*[c,d] = 
    ([a, b] ∩ [1,+∞[) * [c,d] -(-[a,b] ∩ [1,+∞[ * [c,d]) ∪ (([a,b] ∩ [0,0[) * [c,d])*)

(*x⋅y=[min(ac,ad,bc,bd),max(ac,ad,bc,bd)]*)
let sem_times x y =
  match x, y with
  | Bot, _
  | _, Bot -> Bot
  | Itv (a, b), Itv (c,d) -> mk_itv (min(min_option (prod a c) (prod a d)) (min_option (prod b c) (prod b d))) (max(max_option (prod a c) (prod a d)) (max_option (prod b c) (prod b d)))
(*[a,b] / [c,d] = 
   [a,b] / ([c,d] ∩ ]-∞, -1])) ∪ ([a,b] / ([c,d] ∩ [1, +∞[))*)
let sem_div x y = top
  

(* [a,b] ∩ ]0, +∞[ = [max(a, 1), b] *)

let sem_guard = (* t ∩ ]0, +∞[ *)
  function
  | Bot -> Bot
  | Itv (n1, n2) -> mk_itv (if leq_minf (Some 1) n1 then n1 else Some 1) n2

let backsem_plus x y r =
  ((meet x (sem_minus y r)), (meet y (sem_minus x r)))
let backsem_minus x y r =
  ((meet x (sem_plus y r)), (meet y (sem_minus x r)))
let backsem_times x y r = x, y
let backsem_div x y r = x, y
