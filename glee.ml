open Utilities

type datum =
  | Bool   of bool
  | Number of int
  | Symbol of string
  | List   of datum list

type instr =
  | Def   of string * datum list
  | Datum of datum

type stack   = datum list
and  program = instr list
and  dict    = (string * (state -> state)) list
and  state   = program * stack * dict

let rec datum_to_string = function
  | Bool(b)   -> string_of_bool b
  | Number(n) -> string_of_int n
  | Symbol(s) -> s
  | List(xs)  -> "[" ^ (List.map datum_to_string xs |> String.concat " ") ^ "]"

let dump_stack stk =
     stk
  |> List.map datum_to_string
  |> List.rev
  |> String.concat " "
  |> print_endline

let unquote = function
  | List(ds) -> ds
  | d        -> [d]

let instr_of_datum d = Datum(d)
let binOp op         = fun (p, x::y::s, d) -> (p, op(x, y)::s, d)
let binNumOp op      = binOp (function Number(x), Number(y) -> Number(op x y))
let binBoolOp op     = binOp (function Bool(x),   Bool(y)   -> Bool(op x y))
let pushData data    = fun (p, s, d) -> (List.map instr_of_datum data)@p, s, d

let rec primitives : dict = [
  ("clear",  fun (p, s, d) -> p, [], d);
  ("k",      fun (p, x::y::s, d) -> ((unquote(x) |> List.map instr_of_datum)@p, s, d));
  ("cake",   fun (p, x::y::s, d) -> (p, List(unquote(x)@[y])::List(y::unquote(x))::s, d));
  ("uncons", fun (p, List(x::xs)::s, d) -> p, List(xs)::x::s, d);
  ("choose", fun (p, x::y::z::s, d) -> p, (if z = Bool(false) then x::s else y::s), d);
  ("+",      binNumOp(+));
  ("-",      binNumOp(fun x y -> y - x));
  ("*",      binNumOp( * ));
  ("/",      binNumOp(fun x y -> y / x)); 
  ("=",      binOp(fun (x, y) -> Bool(x = y)));
  ("<",      binOp(fun (x, y) -> Bool(y < x)));
  ("not",    fun (p, Bool(b)::s, d) -> p, Bool(not b)::s, d);
  ("and",    binBoolOp(&&));
]
and step (prg, stk, dict) = match prg with
  | []                     -> [], stk, dict
  | Def(name, data)::prg'  -> prg', stk, (name, pushData(data))::dict
  | Datum(Symbol(s))::prg' ->
    (
      try
        (List.assoc s dict)(prg', stk, dict)
      with
        | Not_found ->
          failwith ("Unknown word " ^ s)
        | Match_failure(_, _, _) ->
          failwith ("Cannot use word `" ^ s ^ "` with current stack")
    )
  | Datum(dat)::prg'       ->  prg', dat::stk, dict
and run (prg, stk, dict) =
  if prg = [] then
    stk, dict
  else
    step (prg, stk, dict) |> run
