program euler11;

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

function max2_(a : Longint; b : Longint) : Longint;
begin
  if a > b
  then
    begin
      exit(a);
    end
  else
    begin
      exit(b);
    end;
end;

type u = array of Longint;
type v = array of array of Longint;
function find(n : Longint; m : v; x : Longint; y : Longint; dx : Longint; dy : Longint) : Longint;
begin
  if (x < 0) or (x = 20) or (y < 0) or (y = 20) then
    begin
      exit(-1);
    end
  else if n = 0
  then
    begin
      exit(1);
    end
  else
    begin
      exit(m[y][x] * find(n - 1, m, x + dx, y + dy, dx, dy));
    end;;
end;

type
    tuple_int_int=^tuple_int_int_r;
    tuple_int_int_r = record
      tuple_int_int_field_0 : Longint;
      tuple_int_int_field_1 : Longint;
    end;

type w = array of tuple_int_int;

var
  c : tuple_int_int;
  d : tuple_int_int;
  directions : w;
  dx : Longint;
  dy : Longint;
  e : tuple_int_int;
  f : tuple_int_int;
  g : tuple_int_int;
  h : tuple_int_int;
  i : Longint;
  j : Longint;
  k : tuple_int_int;
  l : tuple_int_int;
  m : v;
  max0 : Longint;
  o : Longint;
  p : Longint;
  q : u;
  r : Longint;
  s : tuple_int_int;
  x : Longint;
  y : Longint;
begin
  SetLength(directions, 8);
  for i := 0 to  8 - 1 do
  begin
    if i = 0 then
      begin
        new(c);
        c^.tuple_int_int_field_0 := 0;
        c^.tuple_int_int_field_1 := 1;
        directions[i] := c;
      end
    else if i = 1 then
      begin
        new(d);
        d^.tuple_int_int_field_0 := 1;
        d^.tuple_int_int_field_1 := 0;
        directions[i] := d;
      end
    else if i = 2 then
      begin
        new(e);
        e^.tuple_int_int_field_0 := 0;
        e^.tuple_int_int_field_1 := -1;
        directions[i] := e;
      end
    else if i = 3 then
      begin
        new(f);
        f^.tuple_int_int_field_0 := -1;
        f^.tuple_int_int_field_1 := 0;
        directions[i] := f;
      end
    else if i = 4 then
      begin
        new(g);
        g^.tuple_int_int_field_0 := 1;
        g^.tuple_int_int_field_1 := 1;
        directions[i] := g;
      end
    else if i = 5 then
      begin
        new(h);
        h^.tuple_int_int_field_0 := 1;
        h^.tuple_int_int_field_1 := -1;
        directions[i] := h;
      end
    else if i = 6
    then
      begin
        new(k);
        k^.tuple_int_int_field_0 := -1;
        k^.tuple_int_int_field_1 := 1;
        directions[i] := k;
      end
    else
      begin
        new(l);
        l^.tuple_int_int_field_0 := -1;
        l^.tuple_int_int_field_1 := -1;
        directions[i] := l;
      end;;;;;;;
  end;
  max0 := 0;
  o := 20;
  SetLength(m, 20);
  for p := 0 to  20 - 1 do
  begin
    SetLength(q, o);
    for r := 0 to  o - 1 do
    begin
      q[r] := read_int_();
      skip();
    end;
    m[p] := q;
  end;
  for j := 0 to  7 do
  begin
    s := directions[j];
    dx := s^.tuple_int_int_field_0;
    dy := s^.tuple_int_int_field_1;
    for x := 0 to  19 do
    begin
      for y := 0 to  19 do
      begin
        max0 := max2_(max0, find(4, m, x, y, dx, dy));
      end;
    end;
  end;
  Write(max0);
  Write(''#10'');
end.


