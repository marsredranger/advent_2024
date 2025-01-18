-- Day 6 Part 2 Advent of Code 2024
local input = require("exampleinput")

DIRECTIONS = { "^", ">", "v", "<" }
PATHS = {"|", "-", "|", "-"}
OBSTRUCTION = "#"
VISITEDPOS = "X"
EMPTYPOS = "."
UPDOWN = "|"
LEFTRIGHT = "-"
CROSS = "+"
NEWOBSTRUCTION = "0"

DIRECTIONDELTA = { ["^"] = {-1,0}, [">"] = {0,1}, ["v"] = {1,0}, ["<"] = {0,-1} }

NUMDIRECTIONS = #DIRECTIONS
STARTDIRECTIONINDEX = 1

MINY = 1
MAXY = #input
MINX = 1
MAXX = #input[1]

STATUS = {"COMPLETE", "LOOP"}
LOOPSFOUND = 0

function deepcopy(orig)
  local copy
  local orig_type = type(orig)
  if orig_type == "table" then
    copy = {}
    for k, v in next, orig, nil do
      copy[deepcopy(k)] = deepcopy(v)
    end
  else
    copy = orig
  end
  return copy
end

local printlab = function(lab, msg)
  msg = msg or ""
  if msg ~= "" then
    print(msg)
  end
  for i in pairs(lab) do
    print(table.concat(lab[i]), " ")
  end
end

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

local getguardpos = function(guardcharacter, lab)
  for y in pairs(lab) do
    for x in pairs(lab[y]) do
      if lab[y][x] == guardcharacter then
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

local getcharfrompos = function(pos, lab)
  if isinbounds(pos) then
    return lab[pos[1]][pos[2]]
  end
  return nil
end

local updatecharfrompos = function(char, pos, lab)
  lab[pos[1]][pos[2]] = char
end
local calcchar = function(directionindex, pos, lab)
  if getcharfrompos(pos, lab) == EMPTYPOS or getcharfrompos(pos, lab) == PATHS[directionindex] then
    return PATHS[directionindex]
  else
    return CROSS
  end
end

local posequal = function(pos1, pos2)
  return pos1[1] == pos2[1] and pos1[2] == pos2[2]
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

local inloop = function(allobs, directionindex, pos)
  for i in pairs(allobs[directionindex]) do
    if posequal(allobs[directionindex][i], pos) then
      return true
    end
  end
  return false
end


local insertobs = function(allobs, pos, directionindex)
  table.insert(allobs[directionindex], pos)
end

local printpos = function(pos, msg)
  msg = msg or ""
  print(msg.."Y : "..pos[1]..", ".."X : "..pos[2])
end

local newlab = function()
  local l =  {
    directionindex=STARTDIRECTIONINDEX,
    lab=deepcopy(input),
    visitedposes={},
    allobs={{},{},{},{}}
  }
  l["guardstartpos"] = getguardpos(DIRECTIONS[STARTDIRECTIONINDEX], l.lab)
  l["guardpos"] = l["guardstartpos"]
  return l
end

local run = function(labdata)
  updatecharfrompos(EMPTYPOS, labdata.guardpos, labdata.lab)
  insertobs(labdata.allobs, labdata.guardpos, labdata.directionindex)
  while(true) do
    insertifunique(labdata.visitedposes, labdata.guardpos)
    local newguardpos = nextpos(labdata.guardpos, labdata.directionindex)
    if isinbounds(nextpos(labdata.guardpos, labdata.directionindex)) then
      if getcharfrompos(newguardpos, labdata.lab) == OBSTRUCTION then
        updatecharfrompos(calcchar(labdata.directionindex, labdata.guardpos, labdata.lab), labdata.guardpos, labdata.lab)
        if inloop(labdata.allobs, labdata.directionindex, newguardpos) then
          return STATUS[2]
        end
        insertobs(labdata.allobs, newguardpos, labdata.directionindex)
        labdata.directionindex = nextdirectionindex(labdata.directionindex)
        updatecharfrompos(CROSS, labdata.guardpos, labdata.lab)
      else getcharfrompos(newguardpos, labdata.lab)
        updatecharfrompos(calcchar(labdata.directionindex, labdata.guardpos, labdata.lab), labdata.guardpos, labdata.lab)
        labdata.guardpos = newguardpos
      end
    else
      updatecharfrompos(calcchar(labdata.directionindex, labdata.guardpos, labdata.lab), labdata.guardpos, labdata.lab)
      return STATUS[1]
    end
  end
end

GUARDSTARTPOS = getguardpos(DIRECTIONS[STARTDIRECTIONINDEX], input)

for y=1,#input do
  for x=1, #input[1] do
    local insertedobstructionpos = newpos(y, x)
    if not posequal(GUARDSTARTPOS, insertedobstructionpos) then
      local lab = newlab()
      updatecharfrompos(OBSTRUCTION, insertedobstructionpos, lab.lab)
      if run(lab) == "LOOP" then
        LOOPSFOUND = LOOPSFOUND + 1
        printpos(insertedobstructionpos, "LOOP CAUSED BY OBSTRUCTION AT : ")
        updatecharfrompos(DIRECTIONS[STARTDIRECTIONINDEX], lab.guardstartpos, lab.lab)
        updatecharfrompos(NEWOBSTRUCTION, insertedobstructionpos, lab.lab)
      end
    end
 end
end

print("LOOPSFOUND : "..LOOPSFOUND)
