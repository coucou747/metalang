
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed;

procedure aaa_00hello is

begin
  String'Write (Text_Streams.Stream (Current_Output), "Hello World" & Character'Val(10));
end;