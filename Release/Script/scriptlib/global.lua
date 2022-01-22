----------------
-- 2022 by Spike

local module = 
{
  test=1,
  IfHunt = true,
  IfStore = false,
  IfLoot = true,
  IngorePathingToMob = false,
}

function module.length(T)
  if T==nil then return 0 end
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function module.Distance(x1,y1,x2,y2) 
    return math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)) 
end

function module.NumToHex(Num,Byte)
  strS = ""
  strI = string.format("%08X",Num)
  for i=0,Byte-1 do
    strS=strS..string.sub(strI,7-i*2,8-i*2).." "
  end
  return strS
end

return module