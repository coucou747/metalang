program prologin_template_charmatrix;

var global_char : char;
var global_has_char : boolean;

procedure skip_char();
begin
   global_has_char := true;
   read(global_char);
end; 
procedure skip();
var
   n : char;
   t : char;
   s : char;
begin
   n := #13;
   t := #10;
   s := #32;
   if not( global_has_char ) then
      skip_char();
   while (global_char = s) or (global_char = n) or (global_char = t) do
   begin
      skip_char();
   end;
end;
function read_char_aux() : char;
begin
   if global_has_char then
      read_char_aux := global_char
   else
   begin
      skip_char();
      read_char_aux := global_char;
   end
end;
function read_char_() : char;
var
   c : char;
begin
   c := read_char_aux();
   skip_char();
   read_char_ := c;
end;
function read_int_() : Longint;
var
   c    : char;
   i    : Longint;
   sign :  Longint;
begin
   i := 0;
   c := read_char_aux();
   if c = '-' then begin
      skip_char();
      sign := -1;
   end
   else
      sign := 1;

   repeat
      c := read_char_aux();
      if (ord(c) <=57) and (ord(c) >= 48) then
      begin
         i := i * 10 + ord(c) - 48;
         skip_char();
      end
      else
         exit(i * sign);
   until false;
end;

type s = array of char;
type u = array of array of char;
function programme_candidat(tableau : u; taille_x : Longint; taille_y : Longint) : Longint;
var
  i : Longint;
  j : Longint;
  out0 : Longint;
begin
  out0 := 0;
  for i := 0 to  taille_y - 1 do
  begin
    for j := 0 to  taille_x - 1 do
    begin
      out0 := out0 + ord(tableau[i][j]) * (i + j * 2);
      Write(tableau[i][j]);
    end;
    Write('--'#10'');
  end;
  exit(out0);
end;


var
  l : u;
  m : Longint;
  p : Longint;
  r : s;
  tableau : u;
  taille_x : Longint;
  taille_y : Longint;
begin
  taille_x := read_int_();
  skip();
  taille_y := read_int_();
  skip();
  SetLength(l, taille_y);
  for m := 0 to  taille_y - 1 do
  begin
    SetLength(r, taille_x);
    for p := 0 to  taille_x - 1 do
    begin
      r[p] := read_char_();
    end;
    skip();
    l[m] := r;
  end;
  tableau := l;
  Write(programme_candidat(tableau, taille_x, taille_y));
  Write(''#10'');
end.


