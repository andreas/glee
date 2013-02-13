open Utilities

let read_program source =
  try
    Parser.program Lexer.token source
  with
    | Lexer.Error msg ->
        failwith (Printf.sprintf "%s%!" msg)
    | Parser.Error ->
        failwith (Printf.sprintf "At offset %d: syntax error.\n%!" (Lexing.lexeme_start source))

let rec repl_loop (stk, dict) =
  (
    try
      print_string "> ";
      let line = read_line() in
      let prg  = read_program (Lexing.from_string line) in
      Glee.run(prg, stk, dict)
    with
      Failure(s) -> print_endline("Error: " ^ s);
      (stk, dict)
  )
  |> fun (stk', dict') -> Glee.dump_stack stk'; (stk', dict')
  |> repl_loop

let main () =
  if Array.length(Sys.argv) > 1 then
    let input     = open_in Sys.argv.(1) in
    let filebuf   = Lexing.from_channel input in
    let stk, dict = Glee.run((read_program filebuf), [], Glee.primitives) in
    close_in input;
    repl_loop(stk, dict)
  else
    repl_loop([], Glee.primitives)
;;

main()
