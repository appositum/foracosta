open Foracosta

let rec repl () =
  print_string "FRC> ";
  let input = read_line () in
  if input = ":q"
  then ()
  else begin
    execute input;
    repl ()
  end

let () =
  let open Sys in
  if Array.length argv > 1
  then
    begin
      let file = argv.(1) in
      if file_exists file
      then file |> read_file |> execute
      else print_endline @@ "File " ^ "\"" ^ file ^ "\"" ^ " not found"
    end
  else repl ()
