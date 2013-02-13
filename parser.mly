%{
  open Glee
%}

%token<int> INT
%token<string> SYMBOL
%token<bool> BOOL
%token LBRACK RBRACK
%token COLON SEMICOLON
%token EOF

%type<Glee.datum> datum
%type<Glee.instr list> program
%start program

%%

program : 
  | instr* EOF { $1 }

instr :
  | datum                         { Datum($1) }
  | COLON SYMBOL datum* SEMICOLON { Def($2, $3) }

datum :
  | INT                  { Number($1) }
  | SYMBOL               { Symbol($1) }
  | BOOL                 { Bool($1)   }
  | LBRACK datum* RBRACK { List($2)   }

