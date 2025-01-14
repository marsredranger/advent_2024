-- PART 1 of DAY 4 2024 of ADVENT OF CODE
local input = require("input")

XMASCOUNT = 0
CHARS = {"X", "M", "A", "S"}
WORDLEN = #CHARS
DIRECTIONS = {
  ["UP"]={0,-1},
  ["DOWN"]={0,1},
  ["LEFT"]={-1,0},
  ["RIGHT"]={1,0},
  ["UP_LEFT"]={-1,-1},
  ["UP_RIGHT"]={1,-1},
  ["DOWN_LEFT"]={-1,1},
  ["DOWN_RIGHT"]={1,1}
}
HEIGHT=#input
WIDTH=#input[1]
STARTCHAR="X"
UPPERX=#input[1]
LOWERX=1
UPPERY=#input
LOWERY=1

local getcharatxy = function(x,y)
  return input[y][x]
end

local xyinbounds = function(x, y)
  if x >= LOWERX and x <= UPPERX and y >= LOWERY and y <= UPPERY then
    return true
  else
    return false
  end
end

for y=1,HEIGHT do
  for x=1,WIDTH do
    local char = getcharatxy(x,y)
    if char == STARTCHAR then
      for _, direction in pairs(DIRECTIONS) do
        local nextcharindex = 2
        local curx = x
        local cury = y
        while(xyinbounds(curx+direction[1], cury+direction[2])) do
          curx=curx+direction[1]
          cury=cury+direction[2]
          if getcharatxy(curx,cury) == CHARS[nextcharindex] then
            nextcharindex = nextcharindex + 1
          else
            break
          end
          if nextcharindex > WORDLEN then
            XMASCOUNT = XMASCOUNT + 1
            break
          end
        end
      end
    end
  end
end

print(XMASCOUNT)
