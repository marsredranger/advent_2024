DISKMAP = require("exampleinput")
DISKMAPLEN = #DISKMAP
FREESPACE = "."
IOTACOUNT = 0

function Iota()
  local result = IOTACOUNT
  IOTACOUNT = IOTACOUNT + 1
  return result
end

function GetCharAtIndex(str, idx)
  return string.sub(str, idx, idx)
end

function RepeatChar(char, n)
  local result = ""
  for _=1, n do
    result = result..char
  end
  return result
end

function ReplaceCharAtIndex(str, idx, char)
  return string.sub(str, 1, idx-1)..char..string.sub(str, idx+1, #str)
end

function SwapChars(str, idx1, idx2)
  local char1 = GetCharAtIndex(str, idx1)
  local char2 = GetCharAtIndex(str, idx2)
  str = ReplaceCharAtIndex(str, idx1, char2)
  str = ReplaceCharAtIndex(str, idx2, char1)
  return str
end

function ExpandDiskMap(diskmap)
  local expandeddiskmap = ""
  local diskmaplen = #diskmap
  for i=1, diskmaplen do
    if i % 2 == 0 then
      -- free space
      expandeddiskmap = expandeddiskmap..RepeatChar(FREESPACE, tonumber(GetCharAtIndex(diskmap, i)))
    else
      -- files
      local fileid = Iota()
      local fileidstr = tostring(fileid)
      expandeddiskmap = expandeddiskmap..RepeatChar(fileidstr, tonumber(GetCharAtIndex(diskmap, i)))
    end
  end
  return expandeddiskmap
end

function LastFileBlock(expandeddiskmap)
  for i=#expandeddiskmap, 1, -1 do
    if GetCharAtIndex(expandeddiskmap, i) ~= FREESPACE then return i end
  end
  return nil
end

function FirstFreeSpace(expandeddiskmap)
  for i=1, #expandeddiskmap, 1 do
    if GetCharAtIndex(expandeddiskmap, i) == FREESPACE then return i end
  end
  return nil
end

function CompactDiskMap(expandeddiskmap)
  while(true) do
    local lastfileblock = LastFileBlock(expandeddiskmap)
    local firstfreespace = FirstFreeSpace(expandeddiskmap)
    if lastfileblock > firstfreespace then
      expandeddiskmap = SwapChars(expandeddiskmap, lastfileblock, firstfreespace)
    else
      return expandeddiskmap
    end
  end
end

function CheckSum(compactdiskmap)
  local result = 0
  local fileid = 0
  for i=1, #compactdiskmap do
    local fileblock = GetCharAtIndex(compactdiskmap, i)
    if fileblock == FREESPACE then
      return result
    else
      result = result + (fileid * tonumber(fileblock))
      fileid = fileid + 1
    end
  end
end

local expandeddiskmap = ExpandDiskMap(DISKMAP)
print("EXPANDED DISK MAP : \n"..expandeddiskmap)
local compactdiskmap = CompactDiskMap(expandeddiskmap)
print("COMPACT DISK MAP : \n"..compactdiskmap)
local checksum = CheckSum(compactdiskmap)
print("CHECK SUM : "..checksum)


