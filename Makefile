glee : main.ml glee.cmo parser.cmo lexer.cmo utilities.cmo
	ocamlc -g -rectypes utilities.cmo	glee.cmo parser.cmo lexer.cmo main.ml -o glee

lexer.cmo : lexer.ml parser.cmo
	ocamlc -c -rectypes lexer.ml

lexer.ml : lexer.mll
	ocamllex lexer.mll

parser.cmo : parser.ml parser.cli glee.cmo
	ocamlc -c -rectypes parser.ml

parser.cli : parser.mli
	ocamlc -c -rectypes parser.mli

parser.ml : parser.mly
	menhir --ocamlc "ocamlc -rectypes" parser.mly

glee.cmo : glee.ml utilities.cmo
	ocamlc -c -rectypes glee.ml

utilities.cmo : utilities.ml
	ocamlc utilities.ml
	
