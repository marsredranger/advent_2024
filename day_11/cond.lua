function Cond(stone)
  if stone == 0 then
    return "ZERO"
  elseif #stone % 2 == 0 then
    return "EVEN_DIG"
  else
    return "MUL_2024"
  end
end
return Cond
