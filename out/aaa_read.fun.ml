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

let main =
  Scanf.scanf "%d"
  (fun  len -> (
                 (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                 (Printf.printf "%d=len\n" len);
                 let len = (len * 2) in
                 (
                   (Printf.printf "len*2=%d\n" len);
                   let len = (len / 2) in
                   ((fun  (b, tab) -> (
                                        (Printf.printf "\n" );
                                        ((fun  (e, tab2) -> Scanf.scanf "%d"
                                        (fun  strlen -> (
                                                          (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                                                          (Printf.printf "%d=strlen\n" strlen);
                                                          ((fun  (g, tab4) -> let k = (strlen - 1) in
                                                          let rec h j =
                                                            (if (j <= k)
                                                             then (
                                                                    (Printf.printf "%c" tab4.(j));
                                                                    (h (j + 1))
                                                                    )
                                                             
                                                             else ()) in
                                                            (h 0)) (Array.init_withenv strlen (fun  toto g -> Scanf.scanf "%c"
                                                          (fun  tmpc -> let c = (int_of_char (tmpc)) in
                                                          (
                                                            (Printf.printf "%c:%d " tmpc c);
                                                            let c = (if (tmpc <> ' ')
                                                                     then let c = ((((c - (int_of_char ('a'))) + 13) mod 26) + (int_of_char ('a'))) in
                                                                     c
                                                                     else c) in
                                                            let f = (char_of_int (c)) in
                                                            ((), f)
                                                            )
                                                          )) ()))
                                                          )
                                        )) (Array.init_withenv len (fun  i_ e -> Scanf.scanf "%d"
                                        (fun  tmpi2 -> (
                                                         (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                                                         (Printf.printf "%d==>%d " i_ tmpi2);
                                                         let d = tmpi2 in
                                                         ((), d)
                                                         )
                                        )) ()))
                                        )
                   ) (Array.init_withenv len (fun  i b -> Scanf.scanf "%d"
                   (fun  tmpi1 -> (
                                    (Scanf.scanf "%[\n \010]" (fun _ -> ()));
                                    (Printf.printf "%d=>%d " i tmpi1);
                                    let a = tmpi1 in
                                    ((), a)
                                    )
                   )) ()))
                   )
                 
                 )
  )

