# tinyOCaml
tiny OCaml interpreter

# Demo
型
```sh
# Main.run "100";;
- : Syntax.value = Syntax.IntVal 100
# Main.run "true";;
- : Syntax.value = Syntax.BoolVal true
# Main.run "[1;2;3;4]";;
- : Syntax.value =
Syntax.ListVal
[Syntax.IntVal 1; Syntax.IntVal 2; Syntax.IntVal 3; Syntax.IntVal 4]
```

基本演算
```sh
# Main.run "10+20";;
- : Syntax.value = Syntax.IntVal 30
# Main.run "10-20";;
- : Syntax.value = Syntax.IntVal (-10)
# Main.run "10*20";;
- : Syntax.value = Syntax.IntVal 200
# Main.run "1 = 1";;
- : Syntax.value = Syntax.BoolVal true
```

制御構文
```sh
# Main.run "if 1 = 1 then 10 else 0";;
- : Syntax.value = Syntax.IntVal 10
# Main.run "if 1 > 2 then 10 else 0";;
- : Syntax.value = Syntax.IntVal 0
# Main.run "if 1 < 2 then true else false";;
- : Syntax.value = Syntax.BoolVal true
```

let文
```sh
# Main.run "let x = 3 + 1 in x + 1";;
- : Syntax.value = Syntax.IntVal 5
# Main.run "let x = 1 in
			let f = fun y -> x + y in
				let x = 2 in
					f (x + 3) ";;
- : Syntax.value = Syntax.IntVal 6
```

let rec文
```sh
# Main.run "let rec f x = if x = 0 then 1 else x * f (x + (-1)) in f 5";;
- : Syntax.value = Syntax.IntVal 120
```

リスト制御構文
```sh
# Main.run "List.hd [1;2;3;4]";;
- : Syntax.value = Syntax.IntVal 1
# Main.run "List.tl [1;2;3;4]";;
- : Syntax.value =
	Syntax.ListVal [Syntax.IntVal 2; Syntax.IntVal 3; Syntax.IntVal 4]
# Main.run "[1;2;3;4] = [1;2;3;4]";;
- : Syntax.value = Syntax.BoolVal true
# Main.run "[1;2] = [1;2;3]";;
- : Syntax.value = Syntax.BoolVal false
# Main.run "[1;2;4;3] = [1;2;3;4]";;
- : Syntax.value = Syntax.BoolVal false
# Main.run "[[1;2];[3;4]] = [[1;2];[3;4]]";;
- : Syntax.value = Syntax.BoolVal true
# Main.run "[[1;2];[3;4]] = [[1;2]]";;
- : Syntax.value = Syntax.BoolVal false
```

型エラー
```sh
# Main.run "10 + true";;
Exception: Failure "integer value expected".
```
