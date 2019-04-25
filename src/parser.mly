%{
open Syntax
%}

// ��ƥ��
%token <string> VAR  // x, y, abc, ...
%token <int> INT     // 0, 1, 2, ...

// �黻��
%token PLUS     // '+'
%token MINUS    // '-'
%token ASTERISK // '*'
%token SLASH    // '/'
%token EQUAL    // '='
%token NOTEQUAL // "<>"
%token LESS     // '<'
%token GREATER  // '>'
%token COLCOL   // "::"

// �����
%token LPAREN   // '('
%token RPAREN   // ')'
%token LBRA     // '['
%token RBRA     // ']'

// ���ڤ국��
%token ARROW    // "->"
%token VBAR     // '|'
%token SC
// �������
%token TRUE     // "true"
%token FALSE    // "false"
%token FUN      // "fun"
%token LET      // "let"
%token REC      // "rec"
%token IN       // "in"
%token IF       // "if"
%token THEN     // "then"
%token ELSE     // "else"
%token MATCH    // "match"
%token WITH     // "with"
%token HEAD     // "List.hd"
%token TAIL     // "List.tl"

// ���浭��
%token EOF 

// �黻��ͥ���� (ͥ���٤��㤤��Τۤ���)
%nonassoc VBAR
%nonassoc IN ELSE ARROW WITH
%left EQUAL NOTEQUAL GREATER LESS
%right COLCOL
%left PLUS MINUS
%left ASTERISK SLASH
%nonassoc UNARY
// �Ǹ��arg_expr�ΰ��ֺ��Υȡ�������¤٤�
%left VAR INT TRUE FALSE LBRA LPAREN

%start main
%type <Syntax.exp> main

%%

// ���ϵ���
main:
  | exp EOF
    { $1 }
;

// �ؿ��ΰ����ˤʤ�뼰
arg_exp:
  | VAR
    { Var $1 }
    
  | INT
    { IntLit $1 }
    
  | TRUE
    { BoolLit true }
    
  | FALSE
    { BoolLit false }
  
  // ���ꥹ��
  | LBRA RBRA
    { Empty }

  | LBRA exp_list RBRA
    { let rec list2cons l = if (l = []) then Empty else Cons(List.hd l,(list2cons(List.tl l))) in list2cons (List.rev $2) }//exp����Cons���Ѵ�������

  // ��̤ǰϤޤ줿��
  | LPAREN exp RPAREN
    { $2 }
;

// ��
exp:
  | arg_exp
    { $1 }

  // �ؿ�Ŭ�� (e1 e2)
  | exp arg_exp
    { App ($1, $2) }

  // ����ȿž -e
  | MINUS exp %prec UNARY
    { Minus (IntLit 0, $2) }

  // e1 + e2
  | exp PLUS exp
    { Plus ($1, $3) }

  // e1 - e2
  | exp MINUS exp
    { Minus ($1, $3) }

  // e1 * e2
  | exp ASTERISK exp
    { Times ($1, $3) }

  // e1 / e2
  | exp SLASH exp
    { Div ($1, $3) }

  // e1 = e2
  | exp EQUAL exp
    { Eq ($1, $3) }

  // e1 <> e2
  | exp NOTEQUAL exp
    { NotEq ($1, $3) }

  // e1 < e2
  | exp LESS exp
    { Less ($1, $3) }

  // e1 > e2
  | exp GREATER exp
    { Greater ($1, $3) }

  // e1 :: e2
  | exp COLCOL exp
    { Cons ($1, $3) }

  // List.hd e
  | HEAD arg_exp
    { Head $2 }

  // List.tl e
  | TAIL arg_exp
    { Tail $2 }

  // fun x -> e
  | FUN VAR ARROW exp
    { Fun ($2, $4) }

  // let x = e1 in e2
  | LET VAR EQUAL exp IN exp
    { Let ($2, $4, $6) }

  // let rec f x = e1 in e2
  | LET REC VAR VAR EQUAL exp IN exp
    { LetRec ($3, $4, $6, $8) }

  // if e1 then e2 else e3
  | IF exp THEN exp ELSE exp
    { If ($2, $4, $6) }

  // match e with ...
  | MATCH exp WITH cases_rev
    { Match ($2, List.rev $4) }
    
  | error
    { 
      let message =
        Printf.sprintf 
          "parse error near characters %d-%d"
          (Parsing.symbol_start ())
	        (Parsing.symbol_end ())
	    in
	    failwith message
	  }
;

exp_list: //�ꥹ��
  | exp
    { [$1] }
  | exp_list SC exp
    { $3 :: $1}
;

// matchʸ��case����
// ��: yacc�ǤϺ��Ƶ��Τۤ��������å������̤����ʤ���
cases_rev:
  | pattern ARROW exp
    { [($1, $3)] }
  | cases_rev VBAR pattern ARROW exp
    { ($3, $5) :: $1 }
;

// �ѥ�����
pattern:
  | VAR
    { Var $1 }
  | INT
    { IntLit $1 }
  | TRUE
    { BoolLit true }
  | FALSE
    { BoolLit false }
  | LBRA RBRA
    { Empty }
  | pattern COLCOL pattern
    { Cons ($1, $3) }
;
