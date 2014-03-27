
let rec max2 a b =
  if a > b then
    a
  else
    b

type bigint = {
  mutable bigint_sign : bool;
  mutable bigint_len : int;
  mutable bigint_chiffres : int array;
};;

let rec read_bigint () =
  let len = Scanf.scanf "%d" (fun x -> x) in
  Scanf.scanf "%[\n \010]" (fun _ -> ());
  let sign = Scanf.scanf "%c" (fun x -> x) in
  Scanf.scanf "%[\n \010]" (fun _ -> ());
  let chiffres = Array.init len (fun _d ->
    let c = Scanf.scanf "%c" (fun x -> x) in
    int_of_char (c) - int_of_char ('0')) in
  for i = 0 to (len - 1) / 2 do
    let tmp = chiffres.(i) in
    chiffres.(i) <- chiffres.(len - 1 - i);
    chiffres.(len - 1 - i) <- tmp
  done;
  Scanf.scanf "%[\n \010]" (fun _ -> ());
  let h = {
    bigint_sign=sign = '+';
    bigint_len=len;
    bigint_chiffres=chiffres;
  } in
  let out_ = h in
  out_

let rec print_bigint a =
  if not a.bigint_sign then
    Printf.printf "%c" '-';
  for i = 0 to a.bigint_len - 1 do
    let e = a.bigint_chiffres.(a.bigint_len - 1 - i) in
    Printf.printf "%d" e
  done

exception Found_1 of bool

let rec bigint_eq a b =
  try
  (* Renvoie vrai si a = b *)
  if a.bigint_sign <> b.bigint_sign then
    raise (Found_1(false))
  else if a.bigint_len <> b.bigint_len then
    raise (Found_1(false))
  else
    begin
      for i = 0 to a.bigint_len - 1 do
        if a.bigint_chiffres.(i) <> b.bigint_chiffres.(i) then
          raise (Found_1(false))
      done;
      raise (Found_1(true))
    end
  with Found_1 (out) -> out

exception Found_2 of bool

let rec bigint_gt a b =
  try
  (* Renvoie vrai si a > b *)
  if a.bigint_sign && not b.bigint_sign then
    raise (Found_2(true))
  else if not a.bigint_sign && b.bigint_sign then
    raise (Found_2(false))
  else
    begin
      if a.bigint_len > b.bigint_len then
        raise (Found_2(a.bigint_sign))
      else if a.bigint_len < b.bigint_len then
        raise (Found_2(not a.bigint_sign))
      else
        for i = 0 to a.bigint_len - 1 do
          let j = a.bigint_len - 1 - i in
          if a.bigint_chiffres.(j) > b.bigint_chiffres.(j) then
            raise (Found_2(a.bigint_sign))
          else if a.bigint_chiffres.(j) < b.bigint_chiffres.(j) then
            raise (Found_2(a.bigint_sign))
        done;
      raise (Found_2(true))
    end
  with Found_2 (out) -> out

let rec bigint_lt a b =
  not (bigint_gt a b)

let rec add_bigint_positif a b =
  (* Une addition ou on en a rien a faire des signes *)
  let len = ref( max2 a.bigint_len b.bigint_len + 1 ) in
  let retenue = ref( 0 ) in
  let chiffres = Array.init (!len) (fun i ->
    let tmp = ref( (!retenue) ) in
    if i < a.bigint_len then
      tmp := (!tmp) + a.bigint_chiffres.(i);
    if i < b.bigint_len then
      tmp := (!tmp) + b.bigint_chiffres.(i);
    retenue := (!tmp) / 10;
    (!tmp) mod 10) in
  if chiffres.((!len) - 1) = 0 then
    len := (!len) - 1;
  let m = {
    bigint_sign=true;
    bigint_len=(!len);
    bigint_chiffres=chiffres;
  } in
  let out_ = m in
  out_

let rec sub_bigint_positif a b =
  (* Une soustraction ou on en a rien a faire des signes
Pré-requis : a > b
*)
  let len = ref( a.bigint_len ) in
  let retenue = ref( 0 ) in
  let chiffres = Array.init (!len) (fun i ->
    let tmp = ref( (!retenue) + a.bigint_chiffres.(i) ) in
    if i < b.bigint_len then
      tmp := (!tmp) - b.bigint_chiffres.(i);
    if (!tmp) < 0 then
      begin
        tmp := (!tmp) + 10;
        retenue := -1
      end
    else
      retenue := 0;
    (!tmp)) in
  while (!len) > 0 && chiffres.((!len) - 1) = 0
  do
      len := (!len) - 1
  done;
  let n = {
    bigint_sign=true;
    bigint_len=(!len);
    bigint_chiffres=chiffres;
  } in
  let out_ = n in
  out_

let rec neg_bigint a =
  let o = {
    bigint_sign=not a.bigint_sign;
    bigint_len=a.bigint_len;
    bigint_chiffres=a.bigint_chiffres;
  } in
  let out_ = o in
  out_

let rec add_bigint a b =
  if a.bigint_sign = b.bigint_sign then
    if a.bigint_sign then
      add_bigint_positif a b
    else
      neg_bigint (add_bigint_positif a b)
  else if a.bigint_sign then
    begin
      (* a positif, b negatif *)
      if bigint_gt a (neg_bigint b) then
        sub_bigint_positif a b
      else
        neg_bigint (sub_bigint_positif b a)
    end
  else
    begin
      (* a negatif, b positif *)
      if bigint_gt (neg_bigint a) b then
        neg_bigint (sub_bigint_positif a b)
      else
        sub_bigint_positif b a
    end

let rec sub_bigint a b =
  add_bigint a (neg_bigint b)

let rec mul_bigint_cp a b =
  (* Cet algorithm est quadratique.
C'est le même que celui qu'on enseigne aux enfants en CP.
D'ou le nom de la fonction. *)
  let len = ref( a.bigint_len + b.bigint_len + 1 ) in
  let chiffres = Array.init (!len) (fun _k ->
    0) in
  for i = 0 to a.bigint_len - 1 do
    let retenue = ref( 0 ) in
    for j = 0 to b.bigint_len - 1 do
      chiffres.(i + j) <- chiffres.(i + j) + (!retenue) + b.bigint_chiffres.(j) * a.bigint_chiffres.(i);
      retenue := chiffres.(i + j) / 10;
      chiffres.(i + j) <- chiffres.(i + j) mod 10
    done;
    chiffres.(i + b.bigint_len) <- chiffres.(i + b.bigint_len) + (!retenue)
  done;
  chiffres.(a.bigint_len + b.bigint_len) <- chiffres.(a.bigint_len + b.bigint_len - 1) / 10;
  chiffres.(a.bigint_len + b.bigint_len - 1) <- chiffres.(a.bigint_len + b.bigint_len - 1) mod 10;
  for _l = 0 to 2 do
    if chiffres.((!len) - 1) = 0 then
      len := (!len) - 1
  done;
  let p = {
    bigint_sign=a.bigint_sign = b.bigint_sign;
    bigint_len=(!len);
    bigint_chiffres=chiffres;
  } in
  let out_ = p in
  out_

let rec bigint_premiers_chiffres a i =
  let q = {
    bigint_sign=a.bigint_sign;
    bigint_len=i;
    bigint_chiffres=a.bigint_chiffres;
  } in
  let out_ = q in
  out_

let rec bigint_shift a i =
  let f = a.bigint_len + i in
  let chiffres = Array.init f (fun k ->
    if k >= i then
      a.bigint_chiffres.(k - i)
    else
      0) in
  let r = {
    bigint_sign=a.bigint_sign;
    bigint_len=a.bigint_len + i;
    bigint_chiffres=chiffres;
  } in
  let out_ = r in
  out_

let rec mul_bigint aa bb =
  if aa.bigint_len < 3 or bb.bigint_len < 3 then
    mul_bigint_cp aa bb
  else
    begin
      (* Algorithme de Karatsuba *)
      let split = max2 aa.bigint_len bb.bigint_len / 2 in
      let a = bigint_shift aa (-split) in
      let b = bigint_premiers_chiffres aa split in
      let c = bigint_shift bb (-split) in
      let d = bigint_premiers_chiffres bb split in
      let amoinsb = sub_bigint a b in
      let cmoinsd = sub_bigint c d in
      let ac = mul_bigint a c in
      let bd = mul_bigint b d in
      let amoinsbcmoinsd = mul_bigint amoinsb cmoinsd in
      let acdec = bigint_shift ac (2 * split) in
      add_bigint (add_bigint acdec bd) (bigint_shift (sub_bigint (add_bigint ac bd) amoinsbcmoinsd) split)
      (* ac × 102k + (ac + bd – (a – b)(c – d)) × 10k + bd *)
    end

(*
Division,
Modulo
Exp
*)
let () =
begin
  let a = (read_bigint ()) in
  let b = (read_bigint ()) in
  print_bigint a;
  Printf.printf ">>1=";
  print_bigint (bigint_shift a (-1));
  Printf.printf "\n";
  print_bigint a;
  Printf.printf "*";
  print_bigint b;
  Printf.printf "=";
  print_bigint (mul_bigint a b);
  Printf.printf "\n";
  print_bigint a;
  Printf.printf "*";
  print_bigint b;
  Printf.printf "=";
  print_bigint (mul_bigint_cp a b);
  Printf.printf "\n";
  print_bigint a;
  Printf.printf "+";
  print_bigint b;
  Printf.printf "=";
  print_bigint (add_bigint a b);
  Printf.printf "\n";
  print_bigint b;
  Printf.printf "-";
  print_bigint a;
  Printf.printf "=";
  print_bigint (sub_bigint b a);
  Printf.printf "\n";
  print_bigint a;
  Printf.printf "-";
  print_bigint b;
  Printf.printf "=";
  print_bigint (sub_bigint a b);
  Printf.printf "\n";
  print_bigint a;
  Printf.printf ">";
  print_bigint b;
  Printf.printf "=";
  let g = bigint_gt a b in
  if g then
    Printf.printf "True"
  else
    Printf.printf "False";
  Printf.printf "\n"
end
 