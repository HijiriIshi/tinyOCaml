(* main.ml *)

(* 構文定義ファイル syntax.ml で定義された exp型を使う *)
open Syntax ;;

(* 与えられた文字列の字句解析と構文解析だけを行う関数 *)
(* parse : string -> exp *)

let parse str = 
  Parser.main Lexer.token 
    (Lexing.from_string str)

let run str = 
	let env = Eval.emptyenv () 
	in let form = parse str 
	in Eval.eval form env

