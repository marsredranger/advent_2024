-- Advent of Code Day 5 part 1 2024
-- Check with updates follow the rules and sum the middle value
-- of each update
local input = require("input")
local rules = input["rules"]
local updates = input["updates"]

VALIDUPDATES = {}
MIDDLETOTAL = 0

local indexof = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

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
  if valid then
    table.insert(VALIDUPDATES, update)
  end
end

for i in pairs(VALIDUPDATES) do
  MIDDLETOTAL = MIDDLETOTAL + VALIDUPDATES[i][math.ceil(#VALIDUPDATES[i]/2)]
end

print(MIDDLETOTAL)
