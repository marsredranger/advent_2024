local input = require('input')

table.sort(input.arr1)
table.sort(input.arr2)

local difference = 0

for i,_ in ipairs(input.arr1) do
  local n1 = input.arr1[i]
  local n2 = input.arr2[i]
  difference = difference + math.abs(n1 - n2)
end

print("DIFFERENCE: " .. tostring(difference))

local similar_arr_1_total = 0

for i,_ in ipairs(input.arr1) do
  local left_list_number = input.arr1[i]
  local count = 0
  for ii,_ in ipairs(input.arr2) do
    if left_list_number == input.arr2[ii] then
      count = count + 1
    end
  end
  similar_arr_1_total = similar_arr_1_total + (count * left_list_number)
end

print("SIMILARITY SCORE: " .. tostring(similar_arr_1_total))

