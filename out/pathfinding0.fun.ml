module Array = struct
  include Array
  let init_withenv len f env =
    let refenv = ref env in
    Array.init len (fun i ->
      let env, out = f i !refenv in
      refenv := env;
      out
    )
end

let rec pathfind_aux cache tab x y posX posY =
  let o () = () in
  (if ((posX = (x - 1)) && (posY = (y - 1)))
   then 0
   else let p () = (o ()) in
   (if ((((posX < 0) || (posY < 0)) || (posX >= x)) || (posY >= y))
    then ((x * y) * 10)
    else let q () = (p ()) in
    (if (tab.(posY).(posX) = '#')
     then ((x * y) * 10)
     else let r () = (q ()) in
     (if (cache.(posY).(posX) <> (- 1))
      then cache.(posY).(posX)
      else (
             cache.(posY).(posX) <- ((x * y) * 10);
             let val1 = (pathfind_aux cache tab x y (posX + 1) posY) in
             let val2 = (pathfind_aux cache tab x y (posX - 1) posY) in
             let val3 = (pathfind_aux cache tab x y posX (posY - 1)) in
             let val4 = (pathfind_aux cache tab x y posX (posY + 1)) in
             let out0 = (1 + ((min (((min (((min (val1) (val2)))) (val3)))) (val4)))) in
             (
               cache.(posY).(posX) <- out0;
               out0
               )
             
             )
      ))))
let pathfind tab x y =
  let cache = (Array.init_withenv y (fun  i () -> let tmp = (Array.init_withenv x (fun  j () -> 
  (
    (Printf.printf "%c" tab.(i).(j));
    let m = (- 1) in
    ((), m)
    )
  ) ()) in
  (
    (Printf.printf "\n" );
    let l = tmp in
    ((), l)
    )
  ) ()) in
  (pathfind_aux cache tab x y 0 0)
let main =
  let x = (Scanf.scanf "%d " (fun x -> x)) in
  let y = (Scanf.scanf "%d " (fun x -> x)) in
  (
    (Printf.printf "%d %d\n" x y);
    let e = (Array.init_withenv y (fun  f () -> let h = (Array.init_withenv x (fun  k () -> Scanf.scanf "%c"
    (fun  g -> let u = g in
    ((), u))) ()) in
    (
      (Scanf.scanf "%[\n \010]" (fun _ -> ()));
      let s = h in
      ((), s)
      )
    ) ()) in
    let tab = e in
    let result = (pathfind tab x y) in
    (Printf.printf "%d" result)
    )
  

