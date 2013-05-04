(*
Tictactoe : un tictactoe avec une IA
*)
(* La structure de donnée *)
type gamestate = {
  mutable cases : int array array;
  mutable firstToPlay : bool;
  mutable note : int;
  mutable ended : bool;
};;

(* Un Mouvement *)
type move = {
  mutable x : int;
  mutable y : int;
};;

(* On affiche l'état *)
let rec print_state g =
  Printf.printf "%s" "\n|";
  for y = 0 to 2 do
    for x = 0 to 2 do
      if g.cases.(x).(y) = 0 then
        Printf.printf "%s" " "
      else if g.cases.(x).(y) = 1 then
        Printf.printf "%s" "O"
      else
        Printf.printf "%s" "X";
      Printf.printf "%s" "|"
    done;
    if y <> 2 then
      Printf.printf "%s" "\n|-|-|-|\n|"
  done;
  Printf.printf "%s" "\n"

(* On dit qui gagne (info stoquées dans g.ended et g.note ) *)
let rec eval_ g =
  let win = ref( 0 ) in
  let freecase = ref( 0 ) in
  for y = 0 to 2 do
    let col = ref( -1 ) in
    let lin = ref( -1 ) in
    for x = 0 to 2 do
      if g.cases.(x).(y) = 0 then
        freecase := (!freecase) + 1;
      let colv = g.cases.(x).(y) in
      let linv = g.cases.(y).(x) in
      if (!col) = -1 && colv <> 0 then
        col := colv
      else if colv <> (!col) then
        col := -2;
      if (!lin) = -1 && linv <> 0 then
        lin := linv
      else if linv <> (!lin) then
        lin := -2
    done;
    if (!col) >= 0 then
      win := (!col)
    else if (!lin) >= 0 then
      win := (!lin)
  done;
  for x = 1 to 2 do
    if g.cases.(0).(0) = x && g.cases.(1).(1) = x && g.cases.(2).(2) = x then
      win := x;
    if g.cases.(0).(2) = x && g.cases.(1).(1) = x && g.cases.(2).(0) = x then
      win := x
  done;
  g.ended <- (!win) <> 0 or (!freecase) = 0;
  if (!win) = 1 then
    g.note <- 1000
  else if (!win) = 2 then
    g.note <- -1000
  else
    g.note <- 0

(* On applique un mouvement *)
let rec apply_move_xy x y g =
  let player = ref( 2 ) in
  if g.firstToPlay then
    player := 1;
  g.cases.(x).(y) <- (!player);
  g.firstToPlay <- not g.firstToPlay

let rec apply_move m g =
  apply_move_xy m.x m.y g

let rec cancel_move_xy x y g =
  g.cases.(x).(y) <- 0;
  g.firstToPlay <- not g.firstToPlay;
  g.ended <- false

let rec cancel_move m g =
  cancel_move_xy m.x m.y g

let rec can_move_xy x y g =
  g.cases.(x).(y) = 0

let rec can_move m g =
  can_move_xy m.x m.y g

(*
Un minimax classique, renvoie la note du plateau
*)
let rec minmax g =
  eval_ g;
  if g.ended then
    g.note
  else
    begin
      let maxNote = ref( -10000 ) in
      if not g.firstToPlay then
        maxNote := 10000;
      for x = 0 to 2 do
        for y = 0 to 2 do
          if can_move_xy x y g then
            begin
              apply_move_xy x y g;
              let currentNote = minmax g in
              cancel_move_xy x y g;
              (* Minimum ou Maximum selon le coté ou l'on joue*)
              if (currentNote > (!maxNote)) = g.firstToPlay then
                maxNote := currentNote
            end
        done
      done;
      (!maxNote)
    end

(*
Renvoie le coup de l'IA
*)
let rec play g =
  let minMove = {
    x=0;
    y=0;
  } in
  let minNote = ref( 10000 ) in
  for x = 0 to 2 do
    for y = 0 to 2 do
      if can_move_xy x y g then
        begin
          apply_move_xy x y g;
          let currentNote = minmax g in
          Printf.printf "%d" x;
          Printf.printf "%s" ", ";
          Printf.printf "%d" y;
          Printf.printf "%s" ", ";
          Printf.printf "%d" currentNote;
          Printf.printf "%s" "\n";
          cancel_move_xy x y g;
          if currentNote < (!minNote) then
            begin
              minNote := currentNote;
              minMove.x <- x;
              minMove.y <- y
            end
        end
    done
  done;
  let bl = minMove.x in
  Printf.printf "%d" bl;
  let bm = minMove.y in
  Printf.printf "%d" bm;
  Printf.printf "%s" "\n";
  minMove

let rec init () =
  let bo = 3 in
  let cases = Array.init (bo) (fun i ->
    let bn = 3 in
    let tab = Array.init (bn) (fun j ->
      0) in
    tab) in
  let out_ = {
    cases=cases;
    firstToPlay=true;
    note=0;
    ended=false;
  } in
  out_

let rec read_move () =
  let x = Scanf.scanf "%d" (fun x -> x) in
  Scanf.scanf "%[\n \010]" (fun _ -> ());
  let y = Scanf.scanf "%d" (fun x -> x) in
  Scanf.scanf "%[\n \010]" (fun _ -> ());
  let out_ = {
    x=x;
    y=y;
  } in
  out_

let () =
begin
  for i = 0 to 1 do
    let state = (init ()) in
    while not state.ended
    do
        print_state state;
        apply_move (play state) state;
        eval_ state;
        print_state state;
        if not state.ended then
          begin
            apply_move (play state) state;
            eval_ state
          end
    done;
    print_state state;
    let bp = state.note in
    Printf.printf "%d" bp;
    Printf.printf "%s" "\n"
  done
end
 