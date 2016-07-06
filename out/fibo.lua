buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([\-0-9]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
--[[
La suite de fibonaci
--]]
function fibo0( a, b, i )
  local out0 = 0
  local a2 = a
  local b2 = b
  for j = 0, i + 1 do
      out0 = out0 + a2
      local tmp = b2
      b2 = b2 + a2
      a2 = tmp
      end
      return out0
  end
  
  
  local a = 0
  local b = 0
  local i = 0
  a = readint()
  stdinsep()
  b = readint()
  stdinsep()
  i = readint()
  io.write(fibo0(a, b, i))
  