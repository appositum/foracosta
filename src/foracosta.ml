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

let tokenize p = many (char ' ') *> p <* many (char ' ')

let integer = tokenize decimal

let push = string "push" *> integer >>= fun x -> return (Push x)
let pop = string "pop" *> return Pop
let add = string "add" *> return Add
let mul = string "mul" *> return Mul

let cmd = add <|> mul <|> pop <|> push

let parse_cmds =
  let eol = end_of_line in
  let eof = end_of_input in
  parse_string (sep_by1 eol cmd <* many eol <* eof)

let rec tokenize (xss : char list) : token list =
  match xss with
  | [] -> []
  | '+' :: xs -> TokenAdd :: tokenize xs
  | '*' :: xs -> TokenMul :: tokenize xs
  | x :: xs ->
    let rest = tokenize xs in
    if is_digit x then TokenNum (to_num x) :: rest else rest
