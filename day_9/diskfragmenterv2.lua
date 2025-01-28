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

function PrintFileBoundaryTable(t)
  print("FILE BOUNDARY TABLE : \n")
  for i, v in pairs(t) do
    print("[" ..i.."] | ".."[startidx] = " ..v["startidx"].." [endidx] = "..v["endidx"].." [filesize] = "..v["filesize"])
  end
end

function PrintFreeTable(t)
  print("FREE SPACE TABLE : \n")
  for i, v in pairs(t) do
    print("[ " .. i .. " ] | [startidx] = " ..v["startidx"].." [endidx] = "..v["endidx"].." [filesize] = "..v["filesize"] )
  end
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

function IsFreeSpaceSplit(fbsize, fssize)
  return fssize > fbsize
end

function InsertFreeSpaceTable(t, freespacetable)
  local insertstartidx = t["startidx"]
  local order = 1
  for i=1, #freespacetable do
    if freespacetable[i]["startidx"] > insertstartidx then
      break
    else
      order = order +1
    end
  end
  table.insert(freespacetable, order, t)
end

function SwapV2(a,curfileid,fileboundarytable,freespaceidx,freespacetable)
  local fbs = fileboundarytable[curfileid]["startidx"]
  local fbe = fileboundarytable[curfileid]["endidx"]
  local fbsize = fileboundarytable[curfileid]["filesize"]
  local fss = freespacetable[freespaceidx]["startidx"]
  local fse = freespacetable[freespaceidx]["endidx"]
  local fssize = freespacetable[freespaceidx]["filesize"]
  -- update diskmap array
  for i=fbs,fbe do
    a[i] = FREESPACE
  end
  for i=fss,fss+fbsize-1  do
    a[i] = curfileid
  end
  -- update fileboundary table
  fileboundarytable[curfileid]["startidx"] = freespacetable[freespaceidx]["startidx"]
  fileboundarytable[curfileid]["endidx"] = freespacetable[freespaceidx]["endidx"]
  -- logic for freespace table is more complicated since it has to be in order of freespace
  -- need to check if we are spliting
  if IsFreeSpaceSplit(fbsize, fssize) then
    -- need to determine order
    -- need to update freespace that already exists, size and startidx
    freespacetable[freespaceidx]["filesize"] = fssize - fbsize
    freespacetable[freespaceidx]["startidx"] = fse - (fssize - fbsize) + 1
    -- need new free space
    -- need to determine position of new freespace in freespacetable
    InsertFreeSpaceTable({
      ["filesize"] = fssize,
      ["startidx"] = fbs,
      ["endidx"] = fbe
    }, freespacetable)
  else
    -- just need to update start and end idx of free space and determine order
    table.remove(freespacetable,freespaceidx)
    InsertFreeSpaceTable({
      ["filesize"] = fssize,
      ["startidx"] = fbs,
      ["endidx"] = fbe
    }, freespacetable)
  end
  print(table.concat(a, ""))
end

function FileSize(a, filenum, s)
  s = s or 1
  local filesize = 0
  local hasmatched = false
  local startidx = nil
  local endidx = nil
  for i=s, #a do
    if a[i] == filenum then
      if not hasmatched then
        startidx = i
        hasmatched = true
      end
      filesize = filesize + 1
      endidx = i
    end
    -- don't need to iterate through the list if we aren't matching the file anymore
    if a[i] ~= filenum and hasmatched then
      break
    end
  end
  if hasmatched then
    return filesize, startidx, endidx
  end
  return nil
end

function FileIdBoundaryTable(a)
  local idx = #a
  local freespaceidx = 1
  local fileboundarytable = {}
  while(true) do
    local filenum = a[idx]
    if filenum ~= FREESPACE then
      local filesize, startidx, endidx = FileSize(a, filenum)
      idx = startidx -1
      fileboundarytable[filenum] = {
        ["filesize"] = filesize,
        ["startidx"] = startidx,
        ["endidx"] = endidx
      }
    else
      idx = idx - 1
    end
    if idx < 1 then
      return fileboundarytable
    end
  end
end

function UpdateFreeSpaceTable()
end

function FreeSpaceTable(a)
  local freespacetable = {}
  local idx = 1
  local order = 1
  while(true) do
    local filechar = a[idx]
    if filechar == FREESPACE then
      local filesize, startidx, endidx = FileSize(a, filechar, idx)
      freespacetable[order] = {
        ["filesize"] = filesize,
        ["startidx"] = startidx,
        ["endidx"] = endidx
      }
      idx = endidx + 1
      order = order + 1
    else
      idx = idx + 1
    end
    if idx >= #a then
      return freespacetable
    end
  end
end

function FindFreeSpace(freespacetable, size, filestartidx)
  for i=1, #freespacetable do
   if filestartidx > freespacetable[i]["startidx"] and freespacetable[i]["filesize"] >= size then
    return i
   end
  end
  return nil
end

function RepairFreeSpaceTable(freespacetable)
  for i=1, #freespacetable-1 do
    if freespacetable[i]["endidx"] == freespacetable[i+1]["startidx"] then
      freespacetable[i]["endidx"] = freespacetable[i+1]["endidx"]
      freespacetable[i]["filesize"] = freespacetable[i]["filesize"] + freespacetable[i+1]["filesize"]
      table.remove(freespacetable, i+1)
      return true
   end
  end
  return false
end

function CompactDiskMapV2(a)
  print(table.concat(a, ""))
  local fileboundarytable = FileIdBoundaryTable(a)
  local freespacetable = FreeSpaceTable(a)
  local fileidx = #a
  while(fileidx>0) do
    local curfileid = a[fileidx]
    if curfileid ~= FREESPACE then
      fileidx = fileidx-1
      local filesize = fileboundarytable[curfileid]["filesize"]
      local freespaceidx = FindFreeSpace(freespacetable, filesize, fileboundarytable[curfileid]["startidx"])
      if freespaceidx then
        -- swap freespace and fileid
        SwapV2(a,curfileid,fileboundarytable,freespaceidx,freespacetable)
        RepairFreeSpaceTable(freespacetable)
      end
    else
      fileidx = fileidx-1
    end
   end
  return a
end


function CheckSumV2(a)
  local result = 0
  local fileid = Iota(true)
  for i=1, #a do
    local fileblock = a[i]
    if fileblock ~= FREESPACE then
      result = result + (fileid * fileblock)
    end
    fileid = Iota()
  end
  return result
end

local emdarray = ExpandedDMArray(DISKMAP)
emdarray = CompactDiskMapV2(emdarray)
print("CHECK SUM : "..CheckSumV2(emdarray))
--
