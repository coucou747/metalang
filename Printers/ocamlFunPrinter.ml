(*
 * Copyright (c) 2012, Prologin
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *)

open Stdlib
open Helper

module E = AstFun.Expr
module Type = Ast.Type

let format_to_string li =
  let li = List.map (function
		      | E.IntFormat -> "%d"
		      | E.StringFormat -> "%s"
		      | E.CharFormat -> "%c"
		      | E.StringConstant s -> String.replace "%" "%%" s
		    ) li
  in String.concat "" li

class camlFunPrinter = object(self)

  method lang () = "ml"

  val mutable macros = StringMap.empty

  val mutable typerEnv : Typer.env = Typer.empty
  method getTyperEnv () = typerEnv
  method setTyperEnv t = typerEnv <- t
  method typename_of_field field = Typer.typename_for_field field typerEnv

  method binopstr = function
  | Ast.Expr.Add -> "+"
  | Ast.Expr.Sub -> "-"
  | Ast.Expr.Mul -> "*"
  | Ast.Expr.Div -> "/"
  | Ast.Expr.Mod -> "mod"
  | Ast.Expr.Or -> "||"
  | Ast.Expr.And -> "&&"
  | Ast.Expr.Lower -> "<"
  | Ast.Expr.LowerEq -> "<="
  | Ast.Expr.Higher -> ">"
  | Ast.Expr.HigherEq -> ">="
  | Ast.Expr.Eq -> "="
  | Ast.Expr.Diff -> "<>"

  method unopstr = function
  | Ast.Expr.Neg -> "-"
  | Ast.Expr.Not -> "not"

  method pbinop f op = Format.fprintf f "%s" (self#binopstr op)
  method punop f op = Format.fprintf f "%s" (self#unopstr op)

  method comment f s c = Format.fprintf f "(* %s *)@\n%a" s self#expr c
  method binop f a op b = Format.fprintf f "(%a %a %a)" self#expr a self#pbinop op self#expr b
  method unop f a op = Format.fprintf f "(%a %a)"self#punop op self#expr a


  method fun_ f params e =
    let pparams, e = self#extract_fun_params (E.fun_ params e) (fun f () -> ()) in
    Format.fprintf f "(fun %a -> %a)" pparams () self#expr e

  method letrecin f name params e1 e2 = match params with
  | [] -> Format.fprintf f "@[<v 2>let rec %a () =@\n%a in@\n%a@]"
    self#binding name
    self#expr e1
    self#expr e2
  | _ ->
    Format.fprintf f "@[<v 2>let rec %a %a =@\n%a in@\n%a@]"
      self#binding name
      (print_list self#binding sep_space) params
      self#expr e1
      self#expr e2

  method funtuple f params e =
    let pparams, e = self#extract_fun_params (E.funtuple params e) (fun f () -> ()) in
    Format.fprintf f "(fun %a -> %a)" pparams () self#expr e

  method binding f s = Format.fprintf f "%s" s

  method print f e ty = match E.unfix e with
  | E.Lief (E.String s) -> Format.fprintf f "(Printf.printf %S)" s
  | _ -> Format.fprintf f "(Printf.printf %S %a)"
    (Printer.format_type ty)
    self#expr e

  method print_format f formats =
    Format.fprintf f "%S" (format_to_string formats)

  method multiprint f formats exprs =
    Format.fprintf f "(Printf.printf %a %a)"
		   self#print_format formats
		   (print_list
		      (fun f (a, ty) -> self#expr f a)
		      sep_space) exprs

  method read f ty next =
    Format.fprintf f "Scanf.scanf %S@\n%a"
      (Printer.format_type ty)
      self#expr next

  method lief f = function
  | E.Error -> Format.fprintf f "(assert false)"
  | E.Unit -> Format.fprintf f "()"
  | E.Char c -> Format.fprintf f "%C" c
  | E.String s -> Format.fprintf f "%S" s
  | E.Integer i -> Format.fprintf f "%i" i
  | E.Bool true -> Format.fprintf f "true"
  | E.Bool false -> Format.fprintf f "false"
  | E.Enum s -> Format.fprintf f "%s" s
  | E.Binding s -> self#binding f s

  method expand_macro_call f name t params code li =
    let lang = self#lang () in
    let code_to_expand = List.fold_left
      (fun acc (clang, expantion) ->
        match acc with
        | Some _ -> acc
        | None ->
          if clang = "" || clang = lang then
            Some expantion
          else None
      ) None
      code
    in match code_to_expand with
    | None -> failwith ("no definition for macro "^name^" in language "^lang)
    | Some s ->
      let listr = List.map
        (fun e ->
          let b = Buffer.create 1 in
          let fb = Format.formatter_of_buffer b in
          Format.fprintf fb "@[<h>%a@]%!" self#expr e;
          Buffer.contents b
        ) li in
      let expanded = List.fold_left
        (fun s ((param, _type), string) ->
          String.replace ("$"^param) string s
        )
        s
        (List.combine params listr)
      in Format.fprintf f "(%s)" expanded

  method apply_nomacros f e li =
    match li with
    | [] -> Format.fprintf f "(%a ())" self#expr e
    | _ -> Format.fprintf f "(%a %a)"
      self#expr e (print_list self#expr sep_space) li

  method apply f e li =
    let default () = self#apply_nomacros f e li in
    match E.unfix e with
    | E.Lief ( E.Binding binding ) ->
      begin match StringMap.find_opt binding macros with
      | None -> default ()
      | Some ((t, params, code)) -> self#expand_macro_call f binding t params code li
      end
    | _ -> default ()

  method tuple f li = Format.fprintf f "(%a)"
    (print_list self#expr sep_c) li

  method if_ f e1 e2 e3 = Format.fprintf f "(@[if %a@\nthen %a@\nelse %a)@]" self#expr e1 self#expr e2 self#expr e3

  method block f li = Format.fprintf f "@[<v 2>(@\n%a@\n)@]@\n"
    (print_list
       self#expr
       (fun f pa a pb b -> Format.fprintf f "%a;@\n%a" pa a pb b)) li

  method expr f e = match E.unfix e with
  | E.LetRecIn (name, params, e1, e2) -> self#letrecin f name params e1 e2
  | E.BinOp (a, op, b) -> self#binop f a op b
  | E.UnOp (a, op) -> self#unop f a op
  | E.Fun (params, e) -> self#fun_ f params e
  | E.FunTuple (params, e) -> self#funtuple f params e
  | E.Apply (e, li) -> self#apply f e li
  | E.Tuple li -> self#tuple f li
  | E.Lief l -> self#lief f l
  | E.Comment (s, c) -> self#comment f s c
  | E.If (e1, e2, e3) -> self#if_ f e1 e2 e3
  | E.Print (e, ty) -> self#print f e ty
  | E.MultiPrint (formats, exprs) -> self#multiprint f formats exprs
  | E.ReadIn (ty, next) -> self#read f ty next
  | E.Skip -> self#skip f
  | E.Block li -> self#block f li
  | E.Record li -> self#record f li
  | E.RecordAccess (record, field) -> self#recordaccess f record field
  | E.RecordAffect (record, field, value) -> self#recordaffect f record field value
  | E.ArrayMake (len, lambda, env) -> self#arraymake f len lambda env
  | E.ArrayInit (len, lambda) -> self#arrayinit f len lambda
  | E.ArrayAccess (tab, indexes) -> self#arrayindex f tab indexes
  | E.ArrayAffect (tab, indexes, v) -> self#arrayaffect f tab indexes v
  | E.LetIn (binding, e, b) -> self#letin f [binding, e] b

  method recordaccess f record field  =
    Format.fprintf f "%a.%s" self#expr record field

  method recordaffect f record field value =
    Format.fprintf f "%a.%s <- %a"
      self#expr record field
      self#expr value

  method record f li =
    Format.fprintf f "{%a}"
      (print_list
	 (fun f (expr, field) -> Format.fprintf f "%s=%a" field self#expr expr)
	 (fun f pa a pb b -> Format.fprintf f "%a;@\n%a" pa a pb b)) li

  method skip f = Format.fprintf f "(Scanf.scanf \"%%[\\n \\010]\" (fun _ -> ()))"

  method arrayinit f len lambda = Format.fprintf f "(Array.init %a %a)" self#expr len self#expr lambda

  method arraymake f len lambda env = Format.fprintf f "(Array.init_withenv %a %a %a)" self#expr len self#expr lambda self#expr env

  method arrayindex f tab indexes =
    Format.fprintf f "%a.(%a)"
      self#expr tab
      (print_list self#expr
	 (fun f pa a pb b -> Format.fprintf f "%a).(%a" pa a pb b)) indexes

  method arrayaffect f tab indexes v =
    Format.fprintf f "%a.(%a) <- %a"
      self#expr tab
      (print_list self#expr
	 (fun f pa a pb b -> Format.fprintf f "%a).(%a" pa a pb b)) indexes
      self#expr v

  method letin f params b  = Format.fprintf f "let %a in@\n%a"
    (print_list
       (fun f (s, a) ->
	 let pparams, a = self#extract_fun_params a (fun f () -> ()) in
	 Format.fprintf f "%a%a = %a"
	   self#binding s pparams () self#expr a
       )
       (fun f pa a pb b -> Format.fprintf f "%a@\nand %a" pa a pb b))
    params
    self#expr b

  (** show a type *)
  method ptype f (t : Type.t ) =
    match Type.Fixed.unfix t with
    | Type.Integer -> Format.fprintf f "int"
    | Type.String -> Format.fprintf f "string"
    | Type.Array a -> Format.fprintf f "%a array" self#ptype a
    | Type.Void ->  Format.fprintf f "void"
    | Type.Bool -> Format.fprintf f "bool"
    | Type.Char -> Format.fprintf f "char"
    | Type.Named n -> Format.fprintf f "%s" n
    | Type.Struct li ->
      Format.fprintf f "{%a}"
        (print_list
           (fun t (name, type_) ->
             Format.fprintf t "mutable %s : %a;" name self#ptype type_
           )
           sep_space
        ) li
    | Type.Enum li ->
      Format.fprintf f "%a"
        (print_list
           (fun t name ->
             Format.fprintf t "%s" name
           )
           (fun t fa a fb b -> Format.fprintf t "%a@\n| %a" fa a fb b)
        ) li
    | Type.Lexems -> assert false
    | Type.Auto -> assert false
    | Type.Tuple li ->
      Format.fprintf f "(%a)"
        (print_list self#ptype (fun t fa a fb b -> Format.fprintf t "%a * %a" fa a fb b)) li

  method is_rec name e =
    E.Writer.Deep.fold (fun acc e -> acc || match E.unfix e with
    | E.Lief (E.Binding n) -> n = name
    | _ -> false) false e

  method extract_fun_params e acc = match E.unfix e with
  | E.Fun ([], e) ->
    let acc f () = Format.fprintf f "%a ()" acc ()
    in self#extract_fun_params e acc
  | E.Fun (params, e) ->
    let acc f () = Format.fprintf f "%a %a" acc () (print_list self#binding sep_space) params
    in self#extract_fun_params e acc
  | E.FunTuple (params, e) ->
    let acc f () = Format.fprintf f "%a (%a)" acc () (print_list self#binding sep_c) params
    in self#extract_fun_params e acc
  | _ -> acc, e

  method toplvl_declare f name e = 
    let pparams, e = self#extract_fun_params e (fun f () -> ()) in
    Format.fprintf f "@[<v 2>let%s %a%a =@\n%a@]@\n" (if self#is_rec name e then " rec" else "")
      self#binding name pparams () self#expr e

  method toplvl_declarety f name ty = Format.fprintf f "@[<v 2>type %a = %a@]@\n"
    self#binding name self#ptype ty

  method decl f d = match d with
  | AstFun.Declaration (name, e) -> self#toplvl_declare f name e
  | AstFun.DeclareType (name, ty) -> self#toplvl_declarety f name ty
  | AstFun.Macro (name, t, params, code) ->
      macros <- StringMap.add
        name (t, params, code)
        macros;
      ()

  method header array_init array_make f _ =
    if array_make then
      Format.fprintf f
	"module Array = struct
  include Array
  let init_withenv len f env =
    let refenv = ref env in
    let tab = Array.init len (fun i ->
      let env, out = f i !refenv in
      refenv := env;
      out
    ) in !refenv, tab
end
"

  method prog (f:Format.formatter) (prog:AstFun.prog) =
    let array_init = AstFun.existsExpr (fun e ->match E.unfix e with
    | E.ArrayInit _ -> true
    | _ -> false ) prog.AstFun.declarations in
    let array_make = AstFun.existsExpr (fun e ->match E.unfix e with
    | E.ArrayMake _ -> true
    | _ -> false ) prog.AstFun.declarations in
    self#header array_init array_make f prog.AstFun.options;
    List.iter (self#decl f) prog.AstFun.declarations

end

let camlFunPrinter = new camlFunPrinter

