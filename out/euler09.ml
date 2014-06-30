
let () =
begin
  (*
	a + b + c = 1000 && a * a + b * b = c * c
	*)
  for a = 1 to 1000 do
    for b = a + 1 to 1000 do
      let c = 1000 - a - b in
      let a2b2 = a * a + b * b in
      let cc = c * c in
      if cc = a2b2 && c > a then
        begin
          Printf.printf "%d\n%d\n%d\n" a b c;
          let d = a * b * c in
          Printf.printf "%d\n" d
        end
    done
  done
end
 