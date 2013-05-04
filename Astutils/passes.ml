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
 *)

(** Some passes
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Stdlib

open Ast
open Fresh
open PassesUtils
open ExpandPasses

let rec returns instrs =
  List.fold_left
    returns_i false instrs
and returns_i acc i = match Instr.unfix i with
  | Instr.Return _ -> true
  | Instr.If (_, li1, li2) ->
    acc or ( (returns li1) && returns li2 )
  | _ -> acc

module IfMerge : SigPass = struct
  type 'a acc = unit;;
  let init_acc () = ();;
  let process () i =
    let rec f acc = function
      | [] -> List.rev acc
      | [i] -> List.rev (i :: acc)
      | hd::tl ->
        match Instr.unfix hd with
          | Instr.If (e, l1, l2) ->
            let l1 = f [] l1 in
            let l2 = f [] l2 in
            if returns l1 then
              let l2 = l2 @ tl in
              let l2 = f [] l2 in
              (Instr.if_ e l1 l2 ) :: acc |> List.rev
            else if returns l2 then
              let l1 = l1 @ tl in
              let l1 = f [] l1 in
              (Instr.if_ e l1 l2 ) :: acc |> List.rev
            else f (hd :: acc) tl
          | _ -> f (hd :: acc) tl
    in
    (), f [] i;;
end

module Rename = struct
  type 'a acc = varname BindingMap.t

  let map = ref BindingMap.empty;;

  let add name =
    map := BindingMap.add name (name ^ "_") !map

  let clear () =
    map := BindingMap.empty

  let init_acc () = !map

  let mapname map name =
    match BindingMap.find_opt name map with
      | Some s -> s
      | None -> name

  let rec mapmutable map m =
    match m |> Mutable.unfix with
      | Mutable.Var v -> Mutable.Var (mapname map v) |> Mutable.fix
      | Mutable.Array (v, li) ->
        Mutable.Array ((mapmutable map v), List.map (process_expr map) li) |> Mutable.fix
      | Mutable.Dot (m, f) ->
        Mutable.Dot ((mapmutable map m), f) |> Mutable.fix

  and process_expr map e =
    let f e = Expr.Fixed.fixa (Expr.Fixed.annot e) (match Expr.Fixed.unfix e with
      | Expr.Access mutable_ ->
        Expr.Access (mapmutable map mutable_)
      | Expr.Call (funname, li) ->
        Expr.Call ((mapname map funname), li)
      | e -> e)
    in Expr.Writer.Deep.map f e

  let rec process_instr map i =
    let i2 = match Instr.Fixed.unfix i with
      | Instr.Declare (v, t, e) ->
        Instr.Declare ( (mapname map v), t, process_expr map e)
      | Instr.Affect (m, e) ->
        Instr.Affect ((mapmutable map m), process_expr map e)
      | Instr.Loop (var, e1, e2, li) ->
        Instr.Loop ( (mapname map var), (process_expr map e1), (process_expr map e2), List.map (process_instr map) li )
      | Instr.While (e, li) ->
        Instr.While ((process_expr map e), List.map (process_instr map) li )
      | Instr.Comment s -> Instr.Comment s
      | Instr.Return e -> Instr.Return (process_expr map e)
      | Instr.AllocArray (name, t, e, None) ->
        Instr.AllocArray ((mapname map name), t, (process_expr map e), None)
      | Instr.AllocArray (name, t, e, Some ((var, li))) ->
        let li2 = List.map (process_instr map) li in
        Instr.AllocArray ((mapname map name), t, (process_expr map e), Some ((var, li2)))
      | Instr.AllocRecord (name, t, el) ->
        Instr.AllocRecord ((mapname map name), t,
                           (List.map
                              (fun (field, e) ->
                                (field, process_expr map e))
                           ) el)
      | Instr.If (e, li1, li2) ->
        Instr.If ((process_expr map e),
                  (List.map (process_instr map) li1 ),
                  (List.map (process_instr map) li2 )
        )
      | Instr.Call (name, li) ->
        Instr.Call ((mapname map name), List.map (process_expr map) li)
      | Instr.Print (t, e) ->
        Instr.Print (t, process_expr map e)
      | Instr.Read (t, m) ->
        Instr.Read (t, mapmutable map m)
      | Instr.DeclRead (t, v)->
        Instr.DeclRead (t, mapname map v)
      | Instr.StdinSep -> Instr.StdinSep
    in Instr.Fixed.fixa (Instr.Fixed.annot i) i2

  let process_main acc m = acc, List.map (process_instr acc) m
  let process acc p =
    let p = match p with
      | Prog.DeclarFun (funname, t, params, instrs) ->
        Prog.DeclarFun (mapname acc funname, t,
                        (List.map (fun (n, t) -> (mapname acc n), t) params),
                        (List.map (process_instr acc) instrs))
      | _ -> p (* TODO *)
    in acc, p
end

module CollectCalls = struct
  type 'a acc = BindingSet.t

  let init_acc () = BindingSet.empty

  let process_expr acc e =
    let f acc e = match Expr.Fixed.unfix e with
      | Expr.Call (funname, _) -> BindingSet.add funname acc
      | e -> acc
    in Expr.Writer.Deep.fold f acc e

  let collect_instr acc i =
    let f acc i =
      match Instr.unfix i with
        | Instr.Call (name, li) ->
          BindingSet.add name acc
        | _ -> acc
    in
    let acc = Instr.Writer.Deep.fold f acc i
    in Instr.fold_expr process_expr acc i

  let process_main acc m = (List.fold_left collect_instr acc m), m

  let process acc p =
    let acc = match p with
      | Prog.DeclarFun (_funname, _t, _params, instrs) ->
        List.fold_left collect_instr (BindingSet.add _funname acc) instrs
      | _ -> acc
    in acc, p
end

module WalkCollectCalls = WalkTop(CollectCalls);;
module WalkNopend = Walk(NoPend);;
module WalkExpandPrint = Walk(ExpandPrint);;
module WalkIfMerge = Walk(IfMerge);;
module WalkAllocArrayExpend = Walk(AllocArrayExpend);;
module WalkExpandReadDecl = Walk(ExpandReadDecl);;
module WalkCheckNaming = WalkTop(CheckingPasses.CheckNaming);;
module WalkRename = WalkTop(Rename);;

module RemoveUselessFunctions = struct
  let apply prog funs =
    let go f (li, used_functions) = match f with
      | Prog.DeclarFun (v, _,_, _)
      | Prog.Macro (v, _, _, _) ->
        if BindingSet.mem v used_functions
        then (f::li, (WalkCollectCalls.fold_fun used_functions f) )
        else (li, used_functions)
      | Prog.Comment _ -> (f::li, used_functions)
      | Prog.DeclareType _ -> (f::li, used_functions)
    in

    let used_functions = WalkCollectCalls.fold
      {prog with Prog.funs = funs } in (* fonctions utilisées dans le
                                          programme (stdlib non comprise) *)
    let funs, _ = List.fold_right go prog.Prog.funs ([], used_functions) in
    let prog = { prog with Prog.funs = funs} in
    prog
end

module ReadAnalysis = struct
  let hasSkip li =
    let f acc i =
      match Instr.unfix i with
        | Instr.StdinSep -> true
        | _ -> acc
    in
    List.fold_left
      (fun acc i ->
        Instr.Writer.Deep.fold
          f
          (f acc i) i)
      false li

  let hasSkip_progitem li =
    List.fold_right
      (fun f b -> match f with
        | Prog.DeclarFun (_, _, _, li) ->
          b || (hasSkip li)
        | _ -> b
      ) li false

  let collectReads acc li =
    let f acc i =
      match Instr.unfix i with
        | Instr.Read(ty, _) ->
          TypeSet.add ty acc
        | _ -> acc in
    List.fold_left
      (fun acc i ->
        Instr.Writer.Deep.fold f
          (f acc i) i)
      acc li

  let collectReads_progitem li =
    List.fold_right
      (fun f acc -> match f with
        | Prog.DeclarFun (_, _, _, li) -> collectReads acc li
        | _ -> acc
      ) li TypeSet.empty

  let apply prog =
    { prog with
      Prog.hasSkip =
        begin
          let acc = hasSkip_progitem prog.Prog.funs
          in acc || (Option.map_default false hasSkip prog.Prog.main )
        end;
      Prog.reads =
        begin
          let acc = collectReads_progitem prog.Prog.funs
          in Option.map_default acc (collectReads acc) prog.Prog.main
        end
    }
end

let no_macro = function
  | Prog.DeclarFun (_, ty, li, instrs) ->
    begin match Type.unfix ty with
      | Type.Lexems -> false
      | _ -> true
    end
  | _ -> true
