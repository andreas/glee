{
  open Parser

  exception Error of string
}

rule token = parse
 | ['\n' ' ' '\t']+                   { token lexbuf             }
 | "-"?['0'-'9']+ as i                { INT(int_of_string i)     }
 | "true"                             { BOOL(true)               }
 | "false"                            { BOOL(false)              }
 | "["                                { LBRACK                   }
 | "]"                                { RBRACK                   }
 | ":"                                { COLON                    }
 | ";"                                { SEMICOLON                }
 | eof                                { EOF                      }
 | ['!' - '9' '<'-'Z' '\\' '^'-'~']+ as sym { SYMBOL(sym)        }
 | _
    { raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
