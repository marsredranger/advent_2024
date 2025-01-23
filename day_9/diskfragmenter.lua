DISKMAP = require("exampleinput")
FREESPACE = "."
IOTACOUNT = 0

function Iota(reset)
  reset = reset or false
  if reset then IOTACOUNT = 0 end
  local result = IOTACOUNT
  IOTACOUNT = IOTACOUNT + 1
  return result
end

function GetCharAtIndex(str, idx)
  return string.sub(str, idx, idx)
end

function ExpandedDMArray(dm)
  local array = {}
  for i=1, #dm do
    if i % 2 == 0 then
      --free space
      local char = GetCharAtIndex(dm, i)
      for _=1, tonumber(char) do
        table.insert(array, FREESPACE)
      end
    else
      -- file
      local fileid = Iota()
      local char = GetCharAtIndex(dm, i)
      for _=1, tonumber(char) do
        table.insert(array, fileid)
      end
    end
  end
  return array
end

function LastFileBlock(a)
  for i=#a, 1, -1 do
   if a[i] ~= FREESPACE then
    return i
   end
  end
  return nil
end

function FirstFreeSpace(a)
  for i=1, #a do
   if a[i] == FREESPACE then
    return i
   end
  end
  return nil
end

function Swap(a, l, f)
  local tmp = a[l]
  a[l] = a[f]
  a[f]  = tmp
  return a
end

function CompactDiskMap(a)
  while(true) do
    local lastfileblock = LastFileBlock(a)
    local firstfreespace = FirstFreeSpace(a)
    print(table.concat(a, " "))
    if lastfileblock > firstfreespace then
      a = Swap(a, lastfileblock, firstfreespace)
    else
      return a
    end
  end
end

function CheckSum(a)
  local result = 0
  local fileid = Iota(true)
  for i=1, #a do
    local fileblock = a[i]
    if fileblock == FREESPACE then
      return result
    else
      result = result + (fileid * fileblock)
      fileid = Iota()
    end
  end
end

local emdarray = ExpandedDMArray(DISKMAP)
emdarray = CompactDiskMap(emdarray)
print("CHECK SUM : "..CheckSum(emdarray))
--
