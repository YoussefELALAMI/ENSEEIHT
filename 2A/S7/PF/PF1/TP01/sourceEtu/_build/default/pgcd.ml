(*  Exercice à rendre **)
(*
  pgcd : int -> int -> int
  calcul le pgcd de deux entiers positifs
  Parametres a, b : int, les nombres dont on veut le pgcd
  Resultat : int, pgdc de a et b
  Precondion : a >= 0 et b >= 0
  Post-condition : resultat positif
*)
let rec pgcd a b = 
  if b = 0 then a
  else if a = 0 then b
  else if a = b then a
  else if a > b then pgcd (a - b) b
  else pgcd a (b - a)

let%test _ = pgcd 0 0 = 0
let%test _ = pgcd 0 8 = 8
let%test _ = pgcd 6 0 = 6
let%test _ = pgcd 9 9 = 9
let%test _ = pgcd 11 17 = 1


