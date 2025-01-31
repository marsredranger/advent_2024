local input = require("exampleinput")
local cond = require("cond")
local rules = require("rules")

function DeepCopy(t)
  local copy
  local orig_type = type(t)
  if orig_type == "table" then
    copy = {}
    for k, v in next, t, nil do
      copy[DeepCopy(k)] = DeepCopy(v)
    end
  else
    copy = t
  end
  return copy
end

function PrintStones(a)
  local str = ""
  for i in ipairs(a) do
    str = str..a[i].." "
  end
  print(str)
end

function Blink(stones)
  local newstones = {}
  for i in ipairs(stones) do
    local result = rules[cond(stones[i])](stones[i])
    for j in ipairs(result) do
      table.insert(newstones, result[j])
    end
  end
  return newstones
end

function Blinker(stones, n)
  local newstones = stones
  for _=1, n do
    newstones = Blink(newstones)
    PrintStones(newstones)
  end
  return newstones
end

local blinks = 25
local stones = Blinker(input,blinks)
print("NUM OF STONES AFTER "..blinks.." BLINKS :"..#stones)
