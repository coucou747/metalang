open Ast
open Stdlib
open Warner
(*
module StringMap = struct
  module H = Hashtbl.Make (struct
    type t = string
    let equal = ( = )
    let hash = Hashtbl.hash
  end)

  type 'a t = 'a H.t
  let empty () = H.create 0
  let add x v h = H.add h x v ; h
  let find x h = H.find h x
end
*)

type result =
  | Integer of int
  | Float of float
  | Bool of bool
  | Char of char
  | String of string
  | Record of result array
  | Array of result array
  | Nil

exception Return of result

let typeof = function
  | Integer _ -> "int"
  | Float _ -> "float"
  | Bool _ -> "bool"
  | Char _ -> "char"
  | String _ -> "string"
  | Record _ -> "record"
  | Array _ -> "array"
  | Nil _ -> "Nil"

let get_array = function
  | Array a -> a
  | x ->
    Printf.printf "Got %s expected array" (typeof x); assert false

let get_integer = function
  | Integer a -> a
  | x ->
    Printf.printf "Got %s expected int" (typeof x); assert false

let get_char = function
  | Char a -> a
  | x ->
    Printf.printf "Got %s expected char" (typeof x); assert false

let get_string = function
  | String a -> a
  | x ->
    Printf.printf "Got %s expected string" (typeof x); assert false

let get_bool = function
  | Bool a -> a
  | x ->
    Printf.printf "Got %s expected bool" (typeof x); assert false

type execenv = result array

type  env = {
  nvars : int;
  vars : int StringMap.t;
  functions :
    (int * (execenv -> unit) ) ref
    StringMap.t;
  tyenv : Typer.env;
}

and precompiledExpr =
  | Result of result
  | WithEnv of (execenv -> result)

let empty_env te =
  {
    tyenv = te;
    nvars = 0;
    vars = StringMap.empty;
    functions = StringMap.empty;
  }

let tyerr loc =
  let () = Printf.printf "Type error %a\n%!"
    ploc loc
  in assert false

let num_op loc ( + ) ( +. ) a b = match a, b with
  | Float i, Float j -> Float (i +. j)
  | Integer i, Integer j -> Integer (i + j)
  | _ -> tyerr loc
let int_op loc f a b = num_op loc f (fun _ _ -> tyerr loc) a b
let num_cmp loc f a b =
  let (<) = Obj.magic f in
  match a, b with
    | Float i, Float j -> Bool (i < j)
    | Integer i, Integer j -> Bool (i < j)
    | Bool i, Bool j -> Bool ( i < j)
    | Char i, Char j -> Bool ( i < j)
    | _ -> tyerr loc
let bool_op loc ( = ) a b = match a, b with
  | Bool i, Bool j -> Bool (i = j)
  | _ -> tyerr loc

let binop loc op a b = match op with
  | Expr.Add -> num_op loc ( + ) ( +. ) a b
  | Expr.Sub -> num_op loc ( - ) ( -. ) a b
  | Expr.Mul -> num_op loc ( * ) ( *. ) a b
  | Expr.Div -> num_op loc ( / ) ( /. ) a b
  | Expr.Mod -> int_op loc ( mod ) a b
  | Expr.LowerEq -> num_cmp loc ( <= ) a b
  | Expr.Lower -> num_cmp loc ( < ) a b
  | Expr.HigherEq -> num_cmp loc ( >= ) a b
  | Expr.Higher -> num_cmp loc ( > ) a b
  | Expr.Eq -> num_cmp loc ( = ) a b
  | Expr.Diff -> num_cmp loc ( <> ) a b
  | Expr.BinOr -> int_op loc ( lor ) a b
  | Expr.BinAnd -> int_op loc ( land ) a b
  | Expr.RShift -> int_op loc ( lsr ) a b
  | Expr.LShift -> int_op loc ( lsl ) a b
  | Expr.Or -> bool_op loc ( || ) a b
  | Expr.And -> bool_op loc ( && ) a b

let init_eenv nvars = Array.make nvars Nil

let find_in_env (env:env) v : int =
  StringMap.find v env.vars

let add_in_env (env:env) v : env * int =
  let out = env.nvars in
  {
    env with
      nvars = out + 1;
      vars = StringMap.add v out env.vars
  }, out

let eval_expr execenv (e : precompiledExpr) :  result = match e with
  | Result r -> r
  | WithEnv f -> f execenv

let index_for_field env field =
  match Type.unfix (Typer.type_of_field env.tyenv field) with
    | Type.Struct (li, _) ->
      let li = List.map fst li |> List.sort String.compare in
      List.indexof field li

let rec precompile_expr (t:Parser.token Expr.t) (env:env): precompiledExpr =
  let loc = PosMap.get (Expr.Fixed.annot t) in
  let res x = Result x in
  match Expr.Fixed.map (fun e -> precompile_expr e env)
    (Expr.Fixed.unfix t) with
      | Expr.Char c -> Char c |> res
      | Expr.String s -> String s |> res
      | Expr.Integer i -> Integer i |> res
      | Expr.Float f -> Float f |> res
      | Expr.Bool b -> Bool b |> res
      | Expr.BinOp (Result a, op, Result b) ->
        binop loc op a b |> res
      | Expr.BinOp (Result a, op, WithEnv b) ->
        WithEnv (fun execenv ->
          binop loc op a (b execenv)
        )
      | Expr.BinOp (WithEnv a, op, Result b) ->
        WithEnv (fun execenv ->
          binop loc op (a execenv) b
        )
      | Expr.BinOp (WithEnv a, op, WithEnv b) ->
        WithEnv (fun execenv ->
          binop loc op (a execenv) (b execenv)
        )
      | Expr.UnOp (Result r, Expr.Neg) ->
        Integer (- (get_integer r  ) ) |>  res
      | Expr.UnOp (WithEnv f, Expr.Neg) ->
        WithEnv (fun execenv ->
          Integer (- (get_integer (f execenv)))
        )
      | Expr.UnOp (Result r, Expr.Not) ->
        Bool (not (get_bool r ) ) |> res
      | Expr.UnOp (WithEnv f, Expr.Not) ->
        WithEnv (fun execenv ->
          Bool (not (get_bool (f execenv)))
        )
      | Expr.Access mut ->
        let mut = mut_val env mut in
        WithEnv (fun execenv ->  mut execenv)
      | Expr.Length arr ->
        let mut = mut_val env arr in
        WithEnv (fun execenv ->
          let a = (mut execenv) |> get_array in
          Integer (Array.length a) )
      | Expr.Call (name, params) -> (* TODO *)
        let call = eval_call env name in
        WithEnv (fun execenv ->
  (* Printf.printf "Call %s\n" name; *)
          let params = List.map (eval_expr execenv) params in
          call params
        )
      (*| Expr.UnOp (Integer i, Expr.BNot) -> Integer (lnot )
        | Expr.UnOp (Float i, Expr.Neg) -> Float (-. i) *)
      | Expr.UnOp (_, _) -> assert false


and mut_setval (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result -> unit =
  match Mutable.unfix mut with
    | Mutable.Var v ->
      begin try
              let out = StringMap.find v env.vars in fun execenv v->
                execenv.(out) <- v
        with Not_found ->
          Printf.printf "Cannot find var %s\n" v; assert false
      end
    | Mutable.Array (m, li) ->
      let m, index = match List.rev li with
        | [index] -> mut_val env m, index
        | index::tl ->
          let tl = List.rev tl in
          let m = mut_val env (Mutable.fix (Mutable.Array (m, tl)) ) in
          m, index
      in
      (fun execenv v ->
        (get_array (m execenv)).
          (get_integer (eval_expr execenv index)) <- v)
    | Mutable.Dot (m, field) ->
      let index = index_for_field env field in
      let m = mut_val env m in
      (fun execenv v ->
        match m execenv with
          | Record map ->
            map.(index) <- v
          | x ->
            Printf.printf "Got %s expected Record\n" (typeof x);
            assert false
      )
and mut_val (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result =
  match Mutable.unfix mut with
    | Mutable.Var v ->
      begin try
              let out = StringMap.find v env.vars in fun execenv ->
                execenv.(out)
        with Not_found ->
(*          StringMap.iter
            (fun k i ->
              Printf.printf "%s=>%d\n" k i
            ) env.vars;*)
          Printf.printf "Cannot find var %s\n" v; assert false
      end
    | Mutable.Array (m, li) ->
      let m = mut_val env m in
      List.fold_left
        (fun m index execenv ->
          (get_array (m execenv)).(get_integer (eval_expr execenv index))
        )
        m
        li
    | Mutable.Dot (m, field) ->
      let index = index_for_field env field in
      let m = mut_val env m in
      (fun execenv ->
        match m execenv with
          | Record map ->
            map.(index)
          | x ->
            Printf.printf "Got %s expected Record\n" (typeof x);
            assert false
      )
and eval_call env name  : result list -> result =
  let r = StringMap.find name env.functions in
  fun paramsv ->
    try
      let (nvars, instrs) = !r in
      let eenv:execenv = init_eenv nvars in
      (*    let () = Printf.printf "calling %s with %d vars\n" name nvars in *)
      let _ = List.fold_left
        (fun f (value:result) ->
          let () = eenv.(f) <- value
          in f+1
        ) 0 paramsv
      in try
           instrs eenv;
  (* let () = Printf.printf "nothing to return...\n%!" in *) Nil
        with Return e ->
        (* Printf.printf "Returning ..."; *) e
    with Not_found ->
      match name, paramsv with
        | "int_of_char", [param] ->
          Integer (int_of_char (get_char param))
        | "float_of_int", [param] ->
          Float (float_of_int (get_integer param))
        | _ -> failwith ("The Macro "^name^" cannot be evaluated with
    "^(string_of_int (List.length paramsv))^" arguments")
and eval_instr env (instr: (env -> precompiledExpr) Instr.t) :
    (env * (execenv -> unit))
    = match Instr.unfix instr with
  | Instr.Declare (varname, _, e) ->
    let e = e env in
    let env, r = add_in_env env varname in
    let f execenv =
  (* Printf.printf "Declare %s\n" varname; *)
      execenv.(r) <- eval_expr execenv e
    in env, f
  | Instr.Affect (mutable_, e) ->
    let mutable_ = Mutable.map_expr (fun f -> f env) mutable_ in
    let mut = mut_setval env mutable_ in
    let e = e env in
    env, (fun execenv -> mut execenv (eval_expr execenv e))
  | Instr.Loop (varname, e1, e2, instrs) ->
    let e1 = e1 env in
    let e2 = e2 env in
    let env, mut = add_in_env env varname in
    let env, instrs = eval_instrs env instrs in
    let f execenv =
      let e1 = eval_expr execenv e1 in
      let e2 = eval_expr execenv e2 in
      let rec f e =
        let () = execenv.(mut) <- e in
        if (get_integer e) > (get_integer e2) then ()
        else
          let () = instrs execenv in
          f (Integer (1 + (get_integer e)))
      in f e1
    in env, f
  | Instr.While (e, instrs) ->
    let env, instrs = eval_instrs env instrs in
    let e = e env in
    let rec f execenv =
      let e = eval_expr execenv e in
      if get_bool e then
        let () = instrs execenv
        in f execenv
      else ()
    in env, f
  | Instr.Comment _ -> env, fun execenv -> ()
  | Instr.Return e ->
    let e = e env in
    env, fun execenv -> raise (Return (eval_expr execenv e))
  | Instr.AllocArray (var, t, e, opt) ->
    let e = e env in
    begin match opt with
      | None ->
        let env, r = add_in_env env var in
        env, (fun execenv ->
          let len = get_integer (eval_expr execenv e) in
          execenv.(r) <- Array (Array.make len Nil)
        )
      | Some ((name, lambda)) ->
        let env, instrs = eval_instrs env lambda in
        let env, rout = add_in_env env var in
        let env, rname = add_in_env env name in
        let f execenv =
          let len = get_integer (eval_expr execenv e) in
          execenv.(rout) <- Array (Array.init len (fun i ->
            let () = execenv.(rname) <- Integer i in
            try
              instrs execenv; Nil
            with Return e -> e
          ))
        in env, f
    end
  | Instr.AllocRecord (var, t, fields) ->
    let fields = List.map (fun (name, e) ->
      index_for_field env name, e env) fields in
    let len = List.length fields in
    let env, r = add_in_env env var in
    let f execenv =
      let record = Array.make len Nil in
      let () = List.iter
        (fun (index, e) ->
          let e = eval_expr execenv e in
          record.(index) <- e
        )
      fields
      in execenv.(r) <- (Record record)
    in env, f
  | Instr.If (e, l1, l2) ->
    let e = e env in
    let env, l1 = eval_instrs env l1 in
    let env, l2 = eval_instrs env l2 in
    let f execenv =
      if get_bool (eval_expr execenv e)
      then l1 execenv
      else l2 execenv
    in env, f
  | Instr.Call (funname, el) ->
    let el = List.map (fun f -> f env) el in
    let call = eval_call env funname in
    let f execenv =
      let el = List.map (eval_expr execenv) el in
      let _ = call el in ()
    in env, f
  | Instr.Print (t, e) ->
    let e = e env in
    let f execenv =
      let e = eval_expr execenv e in
      print t e
    in env, f
  | Instr.Read (t, mut) ->
    let mut = Mutable.map_expr (fun f -> f env) mut in
    let mut = mut_setval env mut
    in env, (fun execenv ->
      read t (fun value -> mut execenv value))
  | Instr.DeclRead (t, var) ->
    let env, r = add_in_env env var in
    env, (fun execenv -> read t (fun v -> execenv.(r) <- v))
  | Instr.StdinSep _ ->
    let f execenv = Scanf.scanf "%[\n \010]" (fun _ -> ()) in
    env, f
and print ty e =
  let () = match Type.unfix ty with
    | Type.Array(ty) ->
      begin
        Array.map (fun e -> print ty e) (get_array e);
        ()
      end
    | Type.Integer -> Printf.printf "%d%!" (get_integer e)
    | Type.Char -> Printf.printf "%c%!" (get_char e)
    | Type.Bool -> if get_bool e
      then Printf.printf "True"
      else Printf.printf "False"
    | Type.String -> Printf.printf "%s%!" (get_string e)
    | _ -> failwith ("cannot print type "^(Type.type_t_to_string ty))
  in ()
and read ty k = match Type.unfix ty with
  | Type.Integer ->
    Scanf.scanf "%d" (fun x ->
      k (Integer x)
    )
  | Type.Char ->
    Scanf.scanf "%c" (fun x ->
      k (Char x)
    )
  | _ -> failwith ("cannot read type "^(Type.type_t_to_string ty))
and eval_instrs env
    (instrs : (env -> precompiledExpr) Ast.Instr.t list)
  : env * (execenv -> unit) =
  let env, precompiled = List.fold_left_map
    (fun env instr ->
      eval_instr env instr
    )
    env instrs
  in env, fun execenv -> List.iter (fun f -> f execenv) precompiled

let rec precompile_instrs li =
  List.map precompile_instr li
and precompile_instr i =
  let i = match Instr.unfix i with
    | Instr.Declare (v, t, e) -> Instr.Declare (v, t, precompile_expr e)
    | Instr.Affect (mut, e) -> Instr.Affect (Mutable.map_expr precompile_expr
                                               mut, precompile_expr e)
    | Instr.Loop (v, e1, e2, li) ->
      Instr.Loop (v,
                  precompile_expr e1,
                  precompile_expr e2,
                  precompile_instrs li)
    | Instr.While (e, li) ->
      Instr.While (precompile_expr e, precompile_instrs li)
    | Instr.Comment s -> Instr.Comment s
    | Instr.Return e -> Instr.Return (precompile_expr e)
    | Instr.AllocArray (v, t, e, opt) ->
      let opt = match opt with
        | None -> None
        | Some ((v, li)) -> Some (v, precompile_instrs li)
      in Instr.AllocArray(v, t, precompile_expr e, opt)
    | Instr.AllocRecord (v, t, li) ->
      let li = List.map
        (fun (name, e) -> (name, precompile_expr e)) li
      in Instr.AllocRecord (v, t, li)
    | Instr.If (e, l1, l2) ->
      Instr.If (precompile_expr e, precompile_instrs l1, precompile_instrs l2)
    | Instr.Call (name, li) -> Instr.Call (name, List.map precompile_expr li)
    | Instr.Print (t, e) -> Instr.Print (t, precompile_expr e)
    | Instr.Read (t, mut) -> Instr.Read (t, Mutable.map_expr precompile_expr mut)
    | Instr.DeclRead (t, v) -> Instr.DeclRead (t, v)
    | Instr.StdinSep -> Instr.StdinSep
  in Instr.Fixed.fix i

let eval_prog (te : Typer.env) (p:Parser.token Prog.t) =
  let f env p = match p with
    | Prog.DeclarFun (var, t, li, instrs) ->
      let nvars = List.length li in
      let thisfunc = ref (0, fun _ -> ()) in
      let env = {env with
        nvars = nvars + 1;
        vars = List.fold_left
          (fun (f, i) (v, _) ->
            (StringMap.add v i f), i+1
          )
          (StringMap.empty, 0) li |> fst;
        functions =
          StringMap.add var
            thisfunc
            env.functions
      }
      in
(*      let () = Printf.printf "Precompiling %s\n" var in *)
      let env, instrs = eval_instrs env (precompile_instrs instrs) in
  (*      let () = Printf.printf "the function %s need %d vars" var env.nvars
          in *)
      let () = thisfunc := (env.nvars, instrs)
      in env
    | Prog.DeclareType _ -> env
    | Prog.Macro (varname, t, li, impls) -> env
    | Prog.Comment s -> env
    | Prog.Global (var, ty, e) -> env (* TODO *)
  in let env = List.fold_left f (empty_env te) p.Prog.funs
  in match p.Prog.main with
    | Some instrs ->
      let env, f = eval_instrs {env with nvars = 0} (precompile_instrs instrs)
      in f (init_eenv ( env.nvars + 1 ))
    | None -> ()
