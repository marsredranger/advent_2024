local input = require("input")

local mulpattern = "mul%((%d+),(%d+)%)"
local dopattern = "do%(%)"
local dontpattern = "don't%(%)"
local pattern = "(don't%(%))(.-)(do%(%))"
local ans = 0

s = string.gsub(input, pattern, "")

for n1, n2 in string.gmatch(s, mulpattern) do
  ans = ans + n1 * n2
end

print(ans)
