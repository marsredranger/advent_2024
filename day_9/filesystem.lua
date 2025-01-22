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


local expandeddiskmap = ""
for i=1, DISKMAPLEN do
  if i % 2 == 0 then
    -- free space
    expandeddiskmap = expandeddiskmap..RepeatChar(FREESPACE, tonumber(GetCharAtIndex(DISKMAP, i)))
  else
    -- files
    local fileid = Iota()
    local fileidstr = tostring(fileid)
    expandeddiskmap = expandeddiskmap..RepeatChar(fileidstr, tonumber(GetCharAtIndex(DISKMAP, i)))
  end
end

print("EXPANDEDDISKMAP : "..expandeddiskmap)

