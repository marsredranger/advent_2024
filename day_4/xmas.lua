-- PART 2 of DAY 4 2024 of ADVENT OF CODE
local input = require("input")

XMASCOUNT = 0
CHARS = {"M", "A", "S"}
WORDLEN = #CHARS
DIRECTIONS = {
  ["UP_LEFT"]={-1,-1},
  ["UP_RIGHT"]={1,-1},
  ["DOWN_LEFT"]={-1,1},
  ["DOWN_RIGHT"]={1,1}
}
HEIGHT=#input
WIDTH=#input[1]
STARTCHAR="M"
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

MIDDLEACORDS = {}

for y=1,HEIGHT do
  for x=1,WIDTH do
    local char = getcharatxy(x,y)
    if char == STARTCHAR then
      for _, direction in pairs(DIRECTIONS) do
        local nextcharindex = 2
        local curx = x
        local cury = y
        local middlex = 0
        local middley = 0
        while(xyinbounds(curx+direction[1], cury+direction[2])) do
          curx=curx+direction[1]
          cury=cury+direction[2]
          if getcharatxy(curx,cury) == CHARS[nextcharindex] then
            if nextcharindex == 2 then
              middlex = curx
              middley = cury
            end
            nextcharindex = nextcharindex + 1
          else
            break
          end
          if nextcharindex > WORDLEN then
            table.insert(MIDDLEACORDS, {middlex,middley})
            break
          end
        end
      end
    end
  end
end

for i=1,#MIDDLEACORDS do
  local x1,y1 = MIDDLEACORDS[i][1], MIDDLEACORDS[i][2]
  for j=i+1, #MIDDLEACORDS do
    local x2, y2 = MIDDLEACORDS[j][1], MIDDLEACORDS[j][2]
    if x1 == x2 and y1 == y2 then
      XMASCOUNT = XMASCOUNT + 1
      break
    end
 end
end

print(XMASCOUNT)









