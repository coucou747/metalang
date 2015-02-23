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

type bigint = {mutable bigint_sign : bool; mutable bigint_len : int; mutable bigint_chiffres : int array;}
let read_bigint len =
  ((fun  (cd, chiffres) -> let cf = ((len - 1) / 2) in
  let rec ce i =
    (if (i <= cf)
     then let tmp = chiffres.(i) in
     (
       chiffres.(i) <- chiffres.(((len - 1) - i));
       chiffres.(((len - 1) - i)) <- tmp;
       (ce (i + 1))
       )
     
     else {bigint_sign=true;
     bigint_len=len;
     bigint_chiffres=chiffres}) in
    (ce 0)) (Array.init_withenv len (fun  j cd -> Scanf.scanf "%c"
  (fun  c -> let cc = (int_of_char (c)) in
  ((), cc))) ()))
let print_bigint a =
  (
    (if (not a.bigint_sign)
     then (Printf.printf "%c" '-')
     else ());
    let cb = (a.bigint_len - 1) in
    let rec ca i =
      (if (i <= cb)
       then (
              (Printf.printf "%d" a.bigint_chiffres.(((a.bigint_len - 1) - i)));
              (ca (i + 1))
              )
       
       else ()) in
      (ca 0)
    )
  
let bigint_eq a b =
  (*  Renvoie vrai si a = b  *)
  (if (a.bigint_sign <> b.bigint_sign)
   then false
   else (if (a.bigint_len <> b.bigint_len)
         then false
         else let bz = (a.bigint_len - 1) in
         let rec by i =
           (if (i <= bz)
            then (if (a.bigint_chiffres.(i) <> b.bigint_chiffres.(i))
                  then false
                  else (by (i + 1)))
            else true) in
           (by 0)))
let bigint_gt a b =
  (*  Renvoie vrai si a > b  *)
  (if (a.bigint_sign && (not b.bigint_sign))
   then true
   else (if ((not a.bigint_sign) && b.bigint_sign)
         then false
         else (if (a.bigint_len > b.bigint_len)
               then a.bigint_sign
               else (if (a.bigint_len < b.bigint_len)
                     then (not a.bigint_sign)
                     else let bx = (a.bigint_len - 1) in
                     let rec bw i =
                       (if (i <= bx)
                        then let j = ((a.bigint_len - 1) - i) in
                        (if (a.bigint_chiffres.(j) > b.bigint_chiffres.(j))
                         then a.bigint_sign
                         else (if (a.bigint_chiffres.(j) < b.bigint_chiffres.(j))
                               then (not a.bigint_sign)
                               else (bw (i + 1))))
                        else true) in
                       (bw 0)))))
let bigint_lt a b =
  (not (bigint_gt a b))
let add_bigint_positif a b =
  (*  Une addition ou on en a rien a faire des signes  *)
  let len = (((max (a.bigint_len) (b.bigint_len))) + 1) in
  let retenue = 0 in
  ((fun  (retenue, chiffres) -> let rec bv len =
                                  (if ((len > 0) && (chiffres.((len - 1)) = 0))
                                   then let len = (len - 1) in
                                   (bv len)
                                   else {bigint_sign=true;
                                   bigint_len=len;
                                   bigint_chiffres=chiffres}) in
                                  (bv len)) (Array.init_withenv len (fun  i retenue -> let tmp = retenue in
  let tmp = (if (i < a.bigint_len)
             then let tmp = (tmp + a.bigint_chiffres.(i)) in
             tmp
             else tmp) in
  let tmp = (if (i < b.bigint_len)
             then let tmp = (tmp + b.bigint_chiffres.(i)) in
             tmp
             else tmp) in
  let retenue = (tmp / 10) in
  let bt = (tmp mod 10) in
  (retenue, bt)) retenue))
let sub_bigint_positif a b =
  (*  Une soustraction ou on en a rien a faire des signes
Pré-requis : a > b
 *)
  let len = a.bigint_len in
  let retenue = 0 in
  ((fun  (retenue, chiffres) -> let rec bs len =
                                  (if ((len > 0) && (chiffres.((len - 1)) = 0))
                                   then let len = (len - 1) in
                                   (bs len)
                                   else {bigint_sign=true;
                                   bigint_len=len;
                                   bigint_chiffres=chiffres}) in
                                  (bs len)) (Array.init_withenv len (fun  i retenue -> let tmp = (retenue + a.bigint_chiffres.(i)) in
  let tmp = (if (i < b.bigint_len)
             then let tmp = (tmp - b.bigint_chiffres.(i)) in
             tmp
             else tmp) in
  ((fun  (retenue, tmp) -> let bq = tmp in
  (retenue, bq)) (if (tmp < 0)
                  then let tmp = (tmp + 10) in
                  let retenue = (- 1) in
                  (retenue, tmp)
                  else let retenue = 0 in
                  (retenue, tmp)))) retenue))
let neg_bigint a =
  {bigint_sign=(not a.bigint_sign);
  bigint_len=a.bigint_len;
  bigint_chiffres=a.bigint_chiffres}
let add_bigint a b =
  (if (a.bigint_sign = b.bigint_sign)
   then (if a.bigint_sign
         then (add_bigint_positif a b)
         else (neg_bigint (add_bigint_positif a b)))
   else (if a.bigint_sign
         then (*  a positif, b negatif  *)
         (if (bigint_gt a (neg_bigint b))
          then (sub_bigint_positif a b)
          else (neg_bigint (sub_bigint_positif b a)))
         else (*  a negatif, b positif  *)
         (if (bigint_gt (neg_bigint a) b)
          then (neg_bigint (sub_bigint_positif a b))
          else (sub_bigint_positif b a))))
let sub_bigint a b =
  (add_bigint a (neg_bigint b))
let mul_bigint_cp a b =
  (*  Cet algorithm est quadratique.
C'est le même que celui qu'on enseigne aux enfants en CP.
D'ou le nom de la fonction.  *)
  let len = ((a.bigint_len + b.bigint_len) + 1) in
  ((fun  (bk, chiffres) -> let bp = (a.bigint_len - 1) in
  let rec bm i =
    (if (i <= bp)
     then let retenue = 0 in
     let bo = (b.bigint_len - 1) in
     let rec bn j retenue =
       (if (j <= bo)
        then (
               chiffres.((i + j)) <- (chiffres.((i + j)) + (retenue + (b.bigint_chiffres.(j) * a.bigint_chiffres.(i))));
               let retenue = (chiffres.((i + j)) / 10) in
               (
                 chiffres.((i + j)) <- (chiffres.((i + j)) mod 10);
                 (bn (j + 1) retenue)
                 )
               
               )
        
        else (
               chiffres.((i + b.bigint_len)) <- (chiffres.((i + b.bigint_len)) + retenue);
               (bm (i + 1))
               )
        ) in
       (bn 0 retenue)
     else (
            chiffres.((a.bigint_len + b.bigint_len)) <- (chiffres.(((a.bigint_len + b.bigint_len) - 1)) / 10);
            chiffres.(((a.bigint_len + b.bigint_len) - 1)) <- (chiffres.(((a.bigint_len + b.bigint_len) - 1)) mod 10);
            let rec bl l len =
              (if (l <= 2)
               then (if ((len <> 0) && (chiffres.((len - 1)) = 0))
                     then let len = (len - 1) in
                     (bl (l + 1) len)
                     else (bl (l + 1) len))
               else {bigint_sign=(a.bigint_sign = b.bigint_sign);
               bigint_len=len;
               bigint_chiffres=chiffres}) in
              (bl 0 len)
            )
     ) in
    (bm 0)) (Array.init_withenv len (fun  k bk -> let bj = 0 in
  ((), bj)) ()))
let bigint_premiers_chiffres a i =
  let len = ((min (i) (a.bigint_len))) in
  let rec bi len =
    (if ((len <> 0) && (a.bigint_chiffres.((len - 1)) = 0))
     then let len = (len - 1) in
     (bi len)
     else {bigint_sign=a.bigint_sign;
     bigint_len=len;
     bigint_chiffres=a.bigint_chiffres}) in
    (bi len)
let bigint_shift a i =
  ((fun  (bh, chiffres) -> {bigint_sign=a.bigint_sign;
  bigint_len=(a.bigint_len + i);
  bigint_chiffres=chiffres}) (Array.init_withenv (a.bigint_len + i) (fun  k bh -> (
  if (k >= i)
  then let bg = a.bigint_chiffres.((k - i)) in
  ((), bg)
  else let bg = 0 in
  ((), bg))) ()))
let rec mul_bigint aa bb =
  (if (aa.bigint_len = 0)
   then aa
   else (if (bb.bigint_len = 0)
         then bb
         else (if ((aa.bigint_len < 3) || (bb.bigint_len < 3))
               then (mul_bigint_cp aa bb)
               else (*  Algorithme de Karatsuba  *)
               let split = (((min (aa.bigint_len) (bb.bigint_len))) / 2) in
               let a = (bigint_shift aa (- split)) in
               let b = (bigint_premiers_chiffres aa split) in
               let c = (bigint_shift bb (- split)) in
               let d = (bigint_premiers_chiffres bb split) in
               let amoinsb = (sub_bigint a b) in
               let cmoinsd = (sub_bigint c d) in
               let ac = (mul_bigint a c) in
               let bd = (mul_bigint b d) in
               let amoinsbcmoinsd = (mul_bigint amoinsb cmoinsd) in
               let acdec = (bigint_shift ac (2 * split)) in
               (add_bigint (add_bigint acdec bd) (bigint_shift (sub_bigint (add_bigint ac bd) amoinsbcmoinsd) split)))))
let log10 a =
  let out0 = 1 in
  let rec bf a out0 =
    (if (a >= 10)
     then let a = (a / 10) in
     let out0 = (out0 + 1) in
     (bf a out0)
     else out0) in
    (bf a out0)
let bigint_of_int i =
  let size = (log10 i) in
  let size = (if (i = 0)
              then let size = 0 in
              size
              else size) in
  ((fun  (ba, t) -> let be = (size - 1) in
  let rec bc k i =
    (if (k <= be)
     then (
            t.(k) <- (i mod 10);
            let i = (i / 10) in
            (bc (k + 1) i)
            )
     
     else {bigint_sign=true;
     bigint_len=size;
     bigint_chiffres=t}) in
    (bc 0 i)) (Array.init_withenv size (fun  j ba -> let z = 0 in
  ((), z)) ()))
let fact_bigint a =
  let one = (bigint_of_int 1) in
  let out0 = one in
  let rec y a out0 =
    (if (not (bigint_eq a one))
     then let out0 = (mul_bigint a out0) in
     let a = (sub_bigint a one) in
     (y a out0)
     else out0) in
    (y a out0)
let sum_chiffres_bigint a =
  let out0 = 0 in
  let x = (a.bigint_len - 1) in
  let rec w i out0 =
    (if (i <= x)
     then let out0 = (out0 + a.bigint_chiffres.(i)) in
     (w (i + 1) out0)
     else out0) in
    (w 0 out0)
let euler20 () =
  let a = (bigint_of_int 15) in
  (*  normalement c'est 100  *)
  let a = (fact_bigint a) in
  (sum_chiffres_bigint a)
let rec bigint_exp a b =
  (if (b = 1)
   then a
   else (if ((b mod 2) = 0)
         then (bigint_exp (mul_bigint a a) (b / 2))
         else (mul_bigint a (bigint_exp a (b - 1)))))
let rec bigint_exp_10chiffres a b =
  let a = (bigint_premiers_chiffres a 10) in
  (if (b = 1)
   then a
   else (if ((b mod 2) = 0)
         then (bigint_exp_10chiffres (mul_bigint a a) (b / 2))
         else (mul_bigint a (bigint_exp_10chiffres a (b - 1)))))
let euler48 () =
  let sum = (bigint_of_int 0) in
  let rec v i sum =
    (if (i <= 100)
     then (*  1000 normalement  *)
     let ib = (bigint_of_int i) in
     let ibeib = (bigint_exp_10chiffres ib i) in
     let sum = (add_bigint sum ibeib) in
     let sum = (bigint_premiers_chiffres sum 10) in
     (v (i + 1) sum)
     else (
            (Printf.printf "euler 48 = " );
            (print_bigint sum);
            (Printf.printf "\n" )
            )
     ) in
    (v 1 sum)
let euler16 () =
  let a = (bigint_of_int 2) in
  let a = (bigint_exp a 100) in
  (*  1000 normalement  *)
  (sum_chiffres_bigint a)
let euler25 () =
  let i = 2 in
  let a = (bigint_of_int 1) in
  let b = (bigint_of_int 1) in
  let rec u a b i =
    (if (b.bigint_len < 100)
     then (*  1000 normalement  *)
     let c = (add_bigint a b) in
     let a = b in
     let b = c in
     let i = (i + 1) in
     (u a b i)
     else i) in
    (u a b i)
let euler29 () =
  let maxA = 5 in
  let maxB = 5 in
  ((fun  (g, a_bigint) -> ((fun  (m, a0_bigint) -> ((fun  (p, b) -> let n = 0 in
  let found = true in
  let rec q found n =
    (if found
     then let min0 = a0_bigint.(0) in
     let found = false in
     let rec s i found min0 =
       (if (i <= maxA)
        then (if (b.(i) <= maxB)
              then (if found
                    then (if (bigint_lt a_bigint.(i) min0)
                          then let min0 = a_bigint.(i) in
                          (s (i + 1) found min0)
                          else (s (i + 1) found min0))
                    else let min0 = a_bigint.(i) in
                    let found = true in
                    (s (i + 1) found min0))
              else (s (i + 1) found min0))
        else (if found
              then let n = (n + 1) in
              let rec r l =
                (if (l <= maxA)
                 then (if ((bigint_eq a_bigint.(l) min0) && (b.(l) <= maxB))
                       then (
                              b.(l) <- (b.(l) + 1);
                              a_bigint.(l) <- (mul_bigint a_bigint.(l) a0_bigint.(l));
                              (r (l + 1))
                              )
                       
                       else (r (l + 1)))
                 else (q found n)) in
                (r 2)
              else (q found n))) in
       (s 2 found min0)
     else n) in
    (q found n)) (Array.init_withenv (maxA + 1) (fun  k p -> let o = 2 in
  ((), o)) ()))) (Array.init_withenv (maxA + 1) (fun  j2 m -> let h = (bigint_of_int j2) in
  ((), h)) ()))) (Array.init_withenv (maxA + 1) (fun  j g -> let f = (bigint_of_int (j * j)) in
  ((), f)) ()))
let main =
  (
    (Printf.printf "%d\n" (euler29 ()));
    let sum = (read_bigint 50) in
    let rec cg i sum =
      (if (i <= 100)
       then (
              (Scanf.scanf "%[\n \010]" (fun _ -> ()));
              let tmp = (read_bigint 50) in
              let sum = (add_bigint sum tmp) in
              (cg (i + 1) sum)
              )
       
       else (
              (Printf.printf "euler13 = " );
              (print_bigint sum);
              (Printf.printf "\neuler25 = %d\neuler16 = %d\n" (euler25 ()) (euler16 ()));
              (euler48 ());
              (Printf.printf "euler20 = %d\n" (euler20 ()));
              let a = (bigint_of_int 999999) in
              let b = (bigint_of_int 9951263) in
              (
                (print_bigint a);
                (Printf.printf ">>1=" );
                (print_bigint (bigint_shift a (- 1)));
                (Printf.printf "\n" );
                (print_bigint a);
                (Printf.printf "*" );
                (print_bigint b);
                (Printf.printf "=" );
                (print_bigint (mul_bigint a b));
                (Printf.printf "\n" );
                (print_bigint a);
                (Printf.printf "*" );
                (print_bigint b);
                (Printf.printf "=" );
                (print_bigint (mul_bigint_cp a b));
                (Printf.printf "\n" );
                (print_bigint a);
                (Printf.printf "+" );
                (print_bigint b);
                (Printf.printf "=" );
                (print_bigint (add_bigint a b));
                (Printf.printf "\n" );
                (print_bigint b);
                (Printf.printf "-" );
                (print_bigint a);
                (Printf.printf "=" );
                (print_bigint (sub_bigint b a));
                (Printf.printf "\n" );
                (print_bigint a);
                (Printf.printf "-" );
                (print_bigint b);
                (Printf.printf "=" );
                (print_bigint (sub_bigint a b));
                (Printf.printf "\n" );
                (print_bigint a);
                (Printf.printf ">" );
                (print_bigint b);
                (Printf.printf "=" );
                let e = (bigint_gt a b) in
                (
                  (if e
                   then (Printf.printf "True")
                   else (Printf.printf "False"));
                  (Printf.printf "\n" )
                  )
                
                )
              
              )
       ) in
      (cg 2 sum)
    )
  

