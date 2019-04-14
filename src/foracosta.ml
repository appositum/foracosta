open Angstrom
open Base

type command =
  | Push of int
  | Pop
  | Add
  | Mul

let unpack s = List.init (String.length s) ~f:(String.get s)
let pack = List.fold_left ~f:(fun acc x -> acc ^ String.make 1 x) ~init:""

let decimal =
  let is_digit = function
    | '0'..'9' -> true
    | _ -> false
  in Int.of_string <$> take_while1 is_digit

let to_num (c : char) : int = int_of_string (String.make 1 c)

let rec tokenize (xss : char list) : token list =
  match xss with
  | [] -> []
  | '+' :: xs -> TokenAdd :: tokenize xs
  | '*' :: xs -> TokenMul :: tokenize xs
  | x :: xs ->
    let rest = tokenize xs in
    if is_digit x then TokenNum (to_num x) :: rest else rest
