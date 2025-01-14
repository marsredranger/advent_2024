local input = require("input")
SAFEREPORTS = 0

function isincreasing(report)
  for i=1, #report-1 do
   if report[i+1] <= report[i] then
      return false
   end
  end
  return true
end

function isdecreasing(report)
  for i=1, #report-1 do
   if report[i+1] >= report[i] then
      return false
   end
  end
  return true
end

function levelsdiffer(report)
  for i=1, #report-1 do
    local diff = math.abs(report[i] - report[i+1])
    if diff > 3  then
      return false
    end
  end
  return true
end

function issafe(report)
  return (isincreasing(report) or isdecreasing(report)) and levelsdiffer(report)
end

for i,_ in pairs(input) do
  print("PROCESSING REPORT : ".. i)
  -- local isinc = isincreasing(input[i])
  -- local isdec = isdecreasing(input[i])
  -- local levelsafe = levelsdiffer(input[i])
  if issafe(input[i]) then
    SAFEREPORTS = SAFEREPORTS + 1
  else
    for j=1, #input[i] do
      local tmp = table.remove(input[i], j)
      if issafe(input[i]) then
        SAFEREPORTS = SAFEREPORTS + 1
        break
      else
        table.insert(input[i],j,tmp)
      end
    end
  end
end

print("SAFE REPORTS : ".. SAFEREPORTS)





