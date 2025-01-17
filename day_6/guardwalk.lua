-- Day 6 Part 1 Advent of Code 2024
local input = require("input")

DIRECTIONS = { "^", ">", "v", "<" }
OBSTRUCTION = "#"
VISITEDPOS = "X"
EMPTYPOS = "."

DIRECTIONDELTA = { ["^"] = {-1,0}, [">"] = {0,1}, ["v"] = {1,0}, ["<"] = {0,-1} }

NUMDIRECTIONS = #DIRECTIONS
STARTDIRECTIONINDEX = 1

MINY = 1
MAXY = #input
MINX = 1
MAXX = #input[1]

local nextdirectionindex = function(directionindex)
  return (directionindex % NUMDIRECTIONS) + 1
end

local newpos = function(y, x)
  return {y, x}
end

local nextpos = function(currpos, directionindex)
  local y = currpos[1] + DIRECTIONDELTA[DIRECTIONS[directionindex]][1]
  local x = currpos[2] + DIRECTIONDELTA[DIRECTIONS[directionindex]][2]
  return  newpos(y, x)
end

local getguardpos = function(guardcharacter)
  for y in pairs(input) do
    for x in pairs(input[y]) do
     if input[y][x] == guardcharacter then
      return newpos(y, x)
     end
    end
  end
  return nil
end

local isinbounds = function(pos)
  if pos[1] < MINY or pos[1] > MAXY or pos[2] < MINX or pos[2] > MAXX then
    return false
  end
  return true
end

local getcharfrompos = function(pos)
  if isinbounds(pos) then
    return input[pos[1]][pos[2]]
  end
  return nil
end

local setcharfrompos = function(char, pos)
  input[pos[1]][pos[2]] = char
end

local insertifunique = function(visitedposes, pos)
  local isunique = true
  for i in pairs(visitedposes) do
    if visitedposes[i][1] == pos[1] and visitedposes[i][2] == pos[2] then
      isunique = false
    end
  end
  if isunique then
    table.insert(visitedposes, pos)
  end
  return visitedposes
end

local printlab = function()
  for i in pairs(input) do
    print(table.concat(input[i]), " ")
  end
end

local printpos = function(pos, msg)
  msg = msg or ""
  print(msg.."Y : "..pos[1]..", ".."X : "..pos[2])
end

local directionindex = STARTDIRECTIONINDEX
local guardpos  = getguardpos(DIRECTIONS[STARTDIRECTIONINDEX])
local visitedposes = {}

while(true) do
  insertifunique(visitedposes, guardpos)
  local newguardpos = nextpos(guardpos, directionindex)
  if isinbounds(nextpos(guardpos, directionindex)) then
    if getcharfrompos(newguardpos) == OBSTRUCTION then
      directionindex = nextdirectionindex(directionindex)
      setcharfrompos(DIRECTIONS[directionindex], guardpos)
    else getcharfrompos(newguardpos)
      setcharfrompos(VISITEDPOS, guardpos)
      setcharfrompos(DIRECTIONS[directionindex], newguardpos)
      guardpos = newguardpos
    end
  else
    setcharfrompos(VISITEDPOS, guardpos)
    break
  end
end

print("NUMBER OF DISTINCT POSES : "..#visitedposes)
