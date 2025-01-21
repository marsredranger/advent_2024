-- Aoc 2024 Day 8 Part 2
local input = require("input")

HEIGHT = #input
WIDTH = #input[1]
MINY = 1
MAXY = HEIGHT
MINX = 1
MAXX = WIDTH

function PrintPos(pos, msg)
  msg = msg or ""
  print(msg.."Y : "..pos[1]..", ".."X : "..pos[2])
end

function PrintAntennasPos(data)
  print("ANTENNAS POS : ")
  for k, v in pairs(data) do
    local str = "["..k.."] :"
    for i in pairs(v) do
      str = str.." ("..v[i][1]..", ".. v[i][2].."), "
    end
    str = str:sub(1,-3)
    print(str)
  end
end

function PrintMatrix(matrix)
  for y in pairs(matrix) do
    local str = ""
    for x in pairs(matrix[y]) do
      str = str..matrix[y][x]
    end
    print(str)
  end
end

function IsInBounds(pos)
  if pos[1] < MINY or pos[1] > MAXY or pos[2] < MINX or pos[2] > MAXX then
    return false
  end
  return true
end

function PosEqual(pos1, pos2)
  return pos1[1] == pos2[1] and pos1[2] == pos2[2]
end

function NewPos(y, x)
  return {y, x}
end

function GetCharFromPos(pos, matrix)
  if IsInBounds(pos) then
    return matrix[pos[1]][pos[2]]
  end
  return nil
end

function UpdateCharFromPos(char, pos, matrix)
  if IsInBounds(pos) then
    matrix[pos[1]][pos[2]] = char
  end
end

function PosAdd(pos1, pos2)
  return NewPos(pos1[1] + pos2[1], pos1[2] + pos2[2])
end

function CalcRiseAndRun(pos1, pos2)
  return pos2[1] - pos1[1], pos2[2] - pos1[2]
end

function CalcSlope(pos1, pos2)
  return (pos2[1] - pos1[1]) / (pos2[2] - pos1[2])
end

function LocateAntennas(matrix)
  local result = {}
  for y=1, #matrix do
    for x=1, #matrix[y] do
      local charpos = NewPos(y, x)
      local char = GetCharFromPos(charpos, matrix)
      if result[char] == nil and char ~= nil and char ~= EMPTYPOS then
        result[char] = {}
      end
      if char ~= EMPTYPOS then
        table.insert(result[char], charpos)
      end
    end
  end
  return result
end

function InsertIfUnique(poses, pos)
  local isunique = true
  for i=1, #poses do
    if poses[i][1] == pos[1] and poses[i][2] == pos[2] then
      isunique = false
    end
  end
  if isunique then
    table.insert(poses, pos)
  end
  return poses
end

EMPTYPOS = "."
ANTINODES = "#"


local antennadata = LocateAntennas(input)
local antinodeposes = {}

for _, v in pairs(antennadata) do
  for i in pairs(v) do
    for j in pairs(v) do
      if not PosEqual(v[i], v[j]) then
        local rise, run = CalcRiseAndRun(v[i], v[j])
        local riserun = NewPos(rise, run)
        local antinodepos = PosAdd(v[j],riserun)
        while (IsInBounds(antinodepos)) do
          if IsInBounds(antinodepos) then
            InsertIfUnique(antinodeposes, antinodepos)
          end
          antinodepos = PosAdd(antinodepos, riserun)
        end
      end
    end
  end
end

for _, v in pairs(antennadata) do
  for i in pairs(v) do
   InsertIfUnique(antinodeposes, v[i])
  end
end
print(#antinodeposes)
