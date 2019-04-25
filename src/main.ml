(* main.ml *)

(* ��ʸ����ե����� syntax.ml ��������줿 exp����Ȥ� *)
open Syntax ;;

(* Ϳ����줿ʸ����λ�����Ϥȹ�ʸ���Ϥ�����Ԥ��ؿ� *)
(* parse : string -> exp *)

let parse str = 
  Parser.main Lexer.token 
    (Lexing.from_string str)

let run str = 
	let env = Eval.emptyenv () 
	in let form = parse str 
	in Eval.eval form env

