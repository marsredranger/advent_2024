-- Day 7 2024 Part 1
-- Program in a list of tables as input
-- Each table in the list is in the form of
-- {{answer} : {operands}}
-- then we generate a product of all possible operators,
-- that is appropriate length given number of operands
-- then we apply each product to see if it will generate the answer
-- if it does we add the answer to a total variable
local input = require("input")
ANSWER = 1
OPERANDS = 2

TOTALCALIBRESULT = 0

function DeepCopy(orig)
  local copy
  local orig_type = type(orig)
  if orig_type == "table" then
    copy = {}
    for k, v in next, orig, nil do
      copy[DeepCopy(k)] = DeepCopy(v)
    end
  else
    copy = orig
  end
  return copy
end

function Push(t)
end

function Pop(t)
end

function ProductRepeat(tab, repeatCount)
  local result = { {} }
  for _ = 1, repeatCount do
    local newResult = { }
    for _, r in ipairs(result) do
      for _, v in ipairs(tab) do
        table.insert(newResult, { v, table.unpack(r) })
      end
    end
    result = newResult
  end
  return result
end

function Add(num1, num2)
  return num1+num2
end

function Mul(num1, num2)
  return num1*num2
end

function PrintTable(t,msg)
  msg = msg or ""
  print(msg..table.concat(t, ", "))
end

OPS = {
  ["+"] = Add,
  ["*"] = Mul
}


for i in pairs(input) do
  local answer = input[i][ANSWER]
  local operands = input[i][OPERANDS]
  local tmp = DeepCopy(operands)
  local operations = ProductRepeat({"*", "+"}, #operands-1)
  local solutionfound = false
  for _, v in ipairs(operations) do
    local stack = {}
    local opsindex = 1
    if not solutionfound then
      for j=1,#tmp do
        if #stack < 2 then
          table.insert(stack, tmp[j])
        end

        if #stack == 2 then
          local result = OPS[v[opsindex]](stack[1], stack[2])
          table.remove(stack, #stack)
          table.remove(stack, #stack)
          table.insert(stack, result)
          opsindex = opsindex +1
        end

        if j==#tmp and stack[1] == answer[1] then
          print("ANSWER FOUND")
          print("ANSWER : "..answer[1])
          print("RESULT : "..stack[1])
          PrintTable(v, "OPERATIONS : ")
          PrintTable(tmp, "OPERANDS : ")
          solutionfound = true
          TOTALCALIBRESULT = TOTALCALIBRESULT + answer[1]
        end
      end
    end
  end
end


print(TOTALCALIBRESULT)
