Rules = {
-- If the stone is engraved with the number 0, 
-- it is replaced by a stone engraved with the number 1.
  ["ZERO"] = function(stone)
    return {1}
  end,
-- If the stone is engraved with a number that has an even number of digits,
-- it is replaced by two stones. 
-- The left half of the digits are engraved on the new left stone, 
-- and the right half of the digits are engraved on the new right stone. 
-- (The new numbers don't keep extra leading zeroes: 
-- 1000 would become stones 10 and 0.)
  ["EVEN_DIG"] = function(stone)
    local s = tostring(stone)
    return {tonumber(s:sub(1,#s/2)),tonumber(s:sub((#s/2)+1,#s))}
  end,
-- If none of the other rules apply, the stone is replaced by a new stone; 
-- the old stone's number multiplied by 2024 is engraved on the new stone.
  ["MUL_2024"] = function(stone)
    return {stone * 2024}
  end
}

return Rules
