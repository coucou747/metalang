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

let programme_candidat tableau1 taille1 tableau2 taille2 =
  let out0 = 0 in
  let h = (taille1 - 1) in
  let rec g i out0 =
    (if (i <= h)
     then let out0 = (out0 + ((int_of_char (tableau1.(i))) * i)) in
     (
       (Printf.printf "%c" tableau1.(i));
       (g (i + 1) out0)
       )
     
     else (
            (Printf.printf "--\n" );
            let f = (taille2 - 1) in
            let rec e j out0 =
              (if (j <= f)
               then let out0 = (out0 + ((int_of_char (tableau2.(j))) * (j * 100))) in
               (
                 (Printf.printf "%c" tableau2.(j));
                 (e (j + 1) out0)
                 )
               
               else (
                      (Printf.printf "--\n" );
                      out0
                      )
               ) in
              (e 0 out0)
            )
     ) in
    (g 0 out0)
let main =
  let taille1 = (Scanf.scanf "%d " (fun x -> x)) in
  let taille2 = (Scanf.scanf "%d " (fun x -> x)) in
  ((fun  (l, tableau1) -> (
                            (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                            ((fun  (o, tableau2) -> (
                                                      (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                                                      (Printf.printf "%d\n" (programme_candidat tableau1 taille1 tableau2 taille2))
                                                      )
                            ) (Array.init_withenv taille2 (fun  c o -> Scanf.scanf "%c"
                            (fun  d -> let m = d in
                            ((), m))) ()))
                            )
  ) (Array.init_withenv taille1 (fun  a l -> Scanf.scanf "%c"
  (fun  b -> let k = b in
  ((), k))) ()))

