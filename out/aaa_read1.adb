
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed;

procedure aaa_read1 is
procedure SkipSpaces is
  C : Character;
  Eol : Boolean;
begin
  loop
    Look_Ahead(C, Eol);
    exit when Eol or C /= ' ';
    Get(C);
  end loop;
end;
type b is Array (Integer range <>) of Character;
type b_PTR is access b;

  str : b_PTR;
begin
  str := new b (0..(12));
  for a in integer range (0)..(12) - (1) loop
    Get(str(a));
  end loop;
  SkipSpaces;
  for i in integer range (0)..(11) loop
    Character'Write (Text_Streams.Stream (Current_Output), str(i));
  end loop;
end;
