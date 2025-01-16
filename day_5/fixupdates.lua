-- Day 5 Part 2 of Advent of Code 2024
-- Uses bubble sort to fix order of invalid updates
local input = require("input")
local updates = input["updates"]
local rules = input["rules"]

INVALIDUPDATES = {}
FIXEDUPDATES = {}
MIDDLETOTAL = 0

local customgreaterthan = function(a, b)
  -- replaces a > b in bubblesort alg
  for i in pairs(rules) do

   local before, after = rules[i][1], rules[i][2]
    if before == a and after == b then
      return false
    elseif before == b and after == a then
       return true
    end
  end
  return false
end

local bubblesort = function(array)
  for i=#array-1, 1,-1 do
    for j=1,i do
      -- if array[j] > a[j+1] then
      if customgreaterthan(array[j], array[j+1]) then
        local temp = array[j]
        array[j] = array[j+1]
        array[j+1] = temp
      end
    end
  end
  return array
end

local indexof = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

-- same code for determing valid updates, but inserts
-- into not valid table
for i in pairs(updates) do
  local update = updates[i]
  local valid = true
  for j in pairs(rules) do
    local before, after = rules[j][1], rules[j][2]
    local beforeindex = indexof(update, before)
    local afterindex = indexof(update, after)
    if beforeindex and afterindex then
      if afterindex < beforeindex then
        valid = false
        break
      end
    end
  end
  if not valid then
    table.insert(INVALIDUPDATES, update)
  end
end

for i in pairs(INVALIDUPDATES) do
  table.insert(FIXEDUPDATES, bubblesort(INVALIDUPDATES[i]))
end

for i in pairs(FIXEDUPDATES) do
  MIDDLETOTAL = MIDDLETOTAL + FIXEDUPDATES[i][math.ceil(#FIXEDUPDATES[i]/2)]
end

print(MIDDLETOTAL)
