module Array = struct
  include Array
  let init_withenv len f env =
    let refenv = ref env in
    let tab = Array.init len (fun i ->
      let env, out = f i !refenv in
      refenv := env;
      out
    ) in !refenv, tab
end

let rec go0 tab a b =
  let m = ((a + b) / 2) in
  (if (a = m)
   then (if (tab.(a) = m)
         then b
         else a)
   else let i = a in
   let j = b in
   let rec c i j =
     (if (i < j)
      then let e = tab.(i) in
      (if (e < m)
       then let i = (i + 1) in
       (c i j)
       else let j = (j - 1) in
       (
         tab.(i) <- tab.(j);
         tab.(j) <- e;
         (c i j)
         )
       )
      else (if (i < m)
            then (go0 tab a m)
            else (go0 tab m b))) in
     (c i j))
let plus_petit0 tab len =
  (go0 tab 0 len)
let main =
  let len = 0 in
  Scanf.scanf "%d"
  (fun  h -> let len = h in
  (
    (Scanf.scanf "%[\n \010]" (fun _ -> ()));
    ((fun  (f, tab) -> (Printf.printf "%d" (plus_petit0 tab len))) (Array.init_withenv len (fun  i f -> let tmp = 0 in
    Scanf.scanf "%d"
    (fun  g -> let tmp = g in
    (
      (Scanf.scanf "%[\n \010]" (fun _ -> ()));
      let d = tmp in
      ((), d)
      )
    )) ()))
    )
  )

