function id( b )
  return b
end

function g( t, index )
  t[index] = false;
end


local j = 0
local a = {}
for i = 0,5 - 1 do
  io.write(i)
  j = j + i;
  a[i] = (math.mod(i, 2)) == 0;
end
io.write(string.format("%d ", j))
local c = a[0]
if c
then
  io.write("True")
else
  io.write("False")
end
io.write("\n")
g(id(a), 0);
local d = a[0]
if d
then
  io.write("True")
else
  io.write("False")
end
io.write("\n")