local input = require("exampleinput")

HEIGHT=#input
WIDTH=#input[1]
UPPERX=#input[1]
LOWERX=1
UPPERY=#input
LOWERY=1

-- UP, RIGHT, DOWN, LEFT
DIRECTIONDELTA={ {-1,0}, {0,1}, {1,0}, {0,-1} }
NUMDIRECTIONS=4

TRAILHEAD = 0
TRAILEND = 9

SUMOFSCORES = 0

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

function PrintTopo(t,c)
  for i, v in pairs(t) do
    print(table.concat(v, " ").." | "..table.concat(c[i]," "))
  end
end

function PrintPos(pos, msg)
  msg = msg or ""
  print(msg.."Y : "..pos[1]..", ".."X : "..pos[2])
end

function PrintPosArray(a)
  for _, v in pairs(a) do
    PrintPos(v)
  end
end

function PrintTrail(m,a)
  for _, v in pairs(a) do
    local msg = "VALUE : "..tostring(GetValueAtPos(m,v)).." AT LOCATION : "
    PrintPos(v,msg)
  end
end

function GetValueAtPos(m,pos)
  return m[pos[1]][pos[2]]
end

function UpdateValueAtPos(m,pos,value)
  m[pos[1]][pos[2]] = value
end


function MarkTrail(m, t)
  for _, v in pairs(t) do
    UpdateValueAtPos(m, v, "X")
  end
end

function IsInBounds(pos)
  return pos[2] >= LOWERX and pos[2] <= UPPERX and pos[1] >= LOWERY and pos[1] <= UPPERY
end

function NewPos(y, x)
  return {y, x}
end

function FindAll(m, value)
  local poses = {}
  for i=LOWERY, UPPERY do
    for j=LOWERX, UPPERX do
      if GetValueAtPos(m,NewPos(i,j)) == value then
        table.insert(poses, NewPos(i,j))
      end
    end
  end
  return poses
end

function IsNextPosValid(m, currpos, nextpos)
  local currvalue = GetValueAtPos(m, currpos)
  local nextvalue = GetValueAtPos(m, nextpos)
  return nextvalue - currvalue == 1
end

function NextPos(currpos, directionindex)
  local nextpos = NewPos(currpos[1] + DIRECTIONDELTA[directionindex][1], currpos[2] + DIRECTIONDELTA[directionindex][2])
  return nextpos
end

function InsertIfUnique(a, pos)
  local isunique = true
  for i in pairs(a) do
    if a[i][1] == pos[1] and a[i][2] == pos[2] then
      isunique = false
      break
    end
  end
  if isunique then
    table.insert(a, pos)
  end
end

function CreateTrails(m,currpos,trail,trails)
  if GetValueAtPos(m, currpos) == TRAILEND then
    table.insert(trails, trail)
    return
  else
    for i=1, NUMDIRECTIONS do
      local trailcopy = DeepCopy(trail)
      local nextpos = NextPos(currpos, i)
      if IsInBounds(nextpos) and IsNextPosValid(m,currpos,nextpos) then
        table.insert(trailcopy, nextpos)
        CreateTrails(m,nextpos,trailcopy,trails)
      end
    end
  end
end

local trailheadposes = FindAll(input, 0)

for _, startpos in pairs(trailheadposes) do
  local trails = {}
  CreateTrails(input, startpos,{startpos},trails)
  local uniqtrailends = {}
  for _, trail in ipairs(trails) do
    local trailend = trail[#trail]
    InsertIfUnique(uniqtrailends,trailend)
  end
  SUMOFSCORES = SUMOFSCORES + #uniqtrailends
end
--
print("SUM OF SCORES : "..SUMOFSCORES)
