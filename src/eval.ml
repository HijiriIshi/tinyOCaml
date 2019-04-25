(* ���η� *)
open Syntax ;;

let value2string va =
	match va with
	| IntVal(v) -> Printf.sprintf "%d" v
	| BoolVal(b) -> Printf.sprintf "%b" b
     | _-> "finish!"
     
(* enptyenv:���Υꥹ�� *)
let emptyenv () = []

let rec printenv env = 
	match env with
	| [] -> (print_string "\n") ; ()
     | (y,v)::tl -> (Printf.printf "%s%s%s%s" y "," (value2string v)  " : ") ; printenv tl
     
     (* ext:�Ķ����ɲ� env-�Ķ� x-�ɲä���̾�� y-�ɲä������ *)
     let ext env x v = (x,v) :: env
     (* lookup: �Ķ�env����ˡ��ѿ�x���б�������֤��֤�*)
     let rec lookup x env = 
          match env with
          | [] -> failwith ("unbound variable: " ^ x)
          | (y,v)::tl -> if x = y then v
          else lookup x tl (* ��Ƭ����õ����tale�ǺƵ� *)

          (* eval: exp -> (string * value) list -> value *)
          (* let ���ѿ����Ķ���Ƴ�� *)
          let rec eval e env =
               let binop f e1 e2 env =
                    match (eval e1 env, eval e2 env) with
                    | (IntVal(n1), IntVal(n2)) -> IntVal(f n1 n2)
                    | _ -> failwith "integer value expected"
                    in
                    match e with
                    | Var(x) -> lookup x env
                    | IntLit(n) -> IntVal(n)
                    | Cons(e1,e2) -> 
                    begin
                         match (eval e1 env, eval e2 env) with
                         | (v1,ListVal(v2)) -> ListVal(v1::v2)
                         | _-> failwith "list cons expected"
                    end
                    | Empty -> ListVal([])
                    | Head(e1) ->
                    begin
                         match (eval e1 env) with
                         | ListVal(v) -> (List.hd v)
                    end
                    | Tail(e1) ->
                    begin
                         match (eval e1 env) with
                         | ListVal(v) -> ListVal(List.tl v)
                    end
                    | Plus(e1,e2) -> binop (+) e2 e1 env
                    | Times(e1,e2) -> binop ( * ) e2 e1 env
                    | Minus(e1,e2) -> binop ( - ) e1 e2 env
                    | Eq(e1, e2) ->
                    let eqop v1 v2 =
                         begin
                              match (v1,v2) with
                              | (IntVal(n1), IntVal(n2)) -> n1 = n2
                              | (BoolVal(b1), BoolVal(b2)) -> b1 = b2
                              | _-> failwith "val eq expected"
                         end
                         in let rec listeq l1 l2 = 
                         begin 
                              match (l1,l2) with
                              | (x::xs,y::ys) -> 
                              begin
                                   match (x,y) with
                                   (*�ꥹ�ȤΥꥹ�Ȥξ��*)
                                   | (ListVal(a),ListVal(b)) -> if ((listeq a b) && (listeq xs ys)) then true else false
                                   (*���̤Υꥹ�Ȥξ��*)
                                   | (_,_) -> if ((eqop x y) && (listeq xs ys)) then true else false
                                   | _-> failwith "listrec"
                              end
                              | ([],[]) -> true
                              | ([],_) -> false
                              | (_,[]) -> false
                              | _-> failwith "listeq"
                         end
                         in
                         begin
                              match (eval e1 env, eval e2 env) with
                              | (ListVal(l1), ListVal(l2)) -> BoolVal(listeq l1 l2)
                              | (v1,v2) -> BoolVal(eqop v1 v2)
                              | _-> failwith "eq match expected"
                         end
                         | If(e1, e2, e3) ->
                         begin
                              match (eval e1 env) with
                              | BoolVal(true) -> eval e2 env
                              | BoolVal(false) -> eval e3 env
                              | _ -> failwith "wrong value"
                         end
                         | Greater(e1, e2) ->
                         begin
                              match (eval e1 env, eval e2 env) with
                              | (IntVal(n1), IntVal(n2)) -> BoolVal(n1 > n2)
                              | _ -> failwith "wrong value"
                         end
                         | Less(e1, e2) ->
                         begin
                              match (eval e1 env, eval e2 env) with
                              | (IntVal(n1), IntVal(n2)) -> BoolVal(n1 < n2)
                              | _ -> failwith "wrong value"
                         end
                         | BoolLit(b) -> BoolVal(b)
                         | Let(x,e1,e2) ->
                         let env1 = ext env x (eval e1 env)
                         in eval e2 env1
                         | Fun(x,e1) -> FunVal (x,e1,env)
                         | App(e1,e2) ->
                         let funpart = (eval e1 env) in (*e1�����ɾ�����ơ�«��->�Ƶ��ΤȤ��˻Ȥ�����*)
                         let arg = (eval e2 env) in
                         begin
                              match (funpart) with
                              | FunVal(x,body,env1) -> (*Func�μ��ΤϤ����Ǽ¹�*)
                              let env2 = (ext env1 x arg) in
                              eval body env2
                              | RecFunVal(f,x,body,env1)-> (*Func�μ��Τ��Ƶ��ؿ��ΤȤ�*)
                              let env2 = (ext (ext env1 x arg) f funpart) in
                              eval body env2
                              | _ -> failwith "function value expcted"
                         end
                         | LetRec(f,x,e1,e2) ->
                         let env1 = ext env f (RecFunVal(f,x,e1,env)) (*RecFunVal���ǴĶ����ɲä��Ƥ���ؿ���ɾ��*)
                         in eval e2 env1
                         | _ -> failwith "unkown expresion";;
