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

let rec eval' stack = function
  | [] -> stack
  | Push n :: xs ->
    Stack.push stack n; eval' stack xs
  | Add :: xs ->
    let new_stack = Stack.create () in
    Stack.push new_stack (Stack.fold stack ~init:0 ~f:(+));
    eval' new_stack xs
  | Mul :: xs ->
    let new_stack = Stack.create () in
    Stack.push new_stack (Stack.fold stack ~init:1 ~f:( * ));
    eval' new_stack xs
  | Pop :: xs ->
    let _ = Stack.pop stack in
    eval' stack xs

let eval = eval' (Stack.create ())

let read_lines filename = 
  let open Caml in
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines
