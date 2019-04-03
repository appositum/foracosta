type token =
  | TokenNum of int
  | TokenAdd
  | TokenMul

type op = Add | Mul

type ast =
  | Val of int
  | App of op * ast list

let unpack s = List.init (String.length s) (String.get s)
let pack = List.fold_left (fun acc x -> acc ^ String.make 1 x) ""

let is_digit = function
  | '0'..'9' -> true
  | _ -> false

let to_num (c : char) : int = int_of_string (String.make 1 c)

let rec tokenize (xss : char list) : token list =
  match xss with
  | [] -> []
  | '+' :: xs -> TokenAdd :: tokenize xs
  | '*' :: xs -> TokenMul :: tokenize xs
  | x :: xs ->
    let rest = tokenize xs in
    if is_digit x then TokenNum (to_num x) :: rest else rest
