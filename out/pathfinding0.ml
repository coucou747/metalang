let min2 a b =
  min a b

let read_char_matrix x y =
  let tab = Array.init y (fun _z ->
    let h = Array.init x (fun _k ->
      let l = Scanf.scanf "%c" (fun v_0 -> v_0) in
      l) in
    Scanf.scanf " " (fun () -> ());
    let g = h in
    g) in
  tab

let rec pathfind_aux cache tab x y posX posY =
  if posX = x - 1 && posY = y - 1 then
    0
  else if posX < 0 or posY < 0 or posX >= x or posY >= y then
    x * y * 10
  else if tab.(posY).(posX) = '#' then
    x * y * 10
  else if cache.(posY).(posX) <> -1 then
    cache.(posY).(posX)
  else
    begin
      cache.(posY).(posX) <- x * y * 10;
      let val1 = pathfind_aux cache tab x y (posX + 1) posY in
      let val2 = pathfind_aux cache tab x y (posX - 1) posY in
      let val3 = pathfind_aux cache tab x y posX (posY - 1) in
      let val4 = pathfind_aux cache tab x y posX (posY + 1) in
      let o = min2 val1 val2 in
      let p = min2 (min2 o val3) val4 in
      let m = p in
      let out_ = 1 + m in
      cache.(posY).(posX) <- out_;
      out_
    end

let pathfind tab x y =
  let cache = Array.init y (fun i ->
    let tmp = Array.init x (fun j ->
      Printf.printf "%c" tab.(i).(j);
      -1) in
    Printf.printf "\n";
    tmp) in
  pathfind_aux cache tab x y 0 0

let () =
begin
  let q = Scanf.scanf "%d " (fun x -> x) in
  let x = q in
  let r = Scanf.scanf "%d " (fun x -> x) in
  let y = r in
  Printf.printf "%d %d\n" x y;
  let tab = read_char_matrix x y in
  let result = pathfind tab x y in
  Printf.printf "%d" result
end
 