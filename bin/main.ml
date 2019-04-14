let rec repl () =
  print_string "FRC> ";
  let input = read_line () in
  if input = ":q"
  then ()
  else (print_endline input; repl ())

let () = repl ()
