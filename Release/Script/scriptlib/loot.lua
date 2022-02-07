----------------
-- 2022 by Spike

local vk = require('virtualkey')
local global =  require('global')


local module = 
{
    Enable= true,  -- enable auto loot function
    LootKey=vk.VK_Z,
    CasualLoot = true, -- loot when you can
    LootStyle = 1,  -- 1 = loot MustPick item immediately, and ignore mobs on the way; 2 = loot MustPick item, but can hunt on the way.
    MustPickType =  -- right now, you can put "Mesos", "Equip", "Use", "Setup" "Etc", e.g. When you put Equip in there, as long as there is Equip, the char must loot it 
    {
        "Equip","Mesos"
    },
    MustPickID =  -- itemID must loot this item 
    {
        4001207,
    },
    LootAttempts=10,  -- if it takes 6 attempts to loot one item, give up, and add that location to Exception
    ExceptionItemNum=6, --how many items we keep in Exception
    Mindis=6,
    JumpKey=vk.VK_ALT
}


local ThisTarget = {x=10000,y=10000}
local Exception = {}
local LootCount  = 0


local function ItemInsideMap(item,left,top,right,bottom)
    return  item.x > left+module.Mindis/2 and item.x < right -module.Mindis/2 
        and item.y > top +module.Mindis/2 and item.y < bottom
end

local function IsMustLoot(item)
    

    for k, ex in pairs(Exception) do
        if math.abs(item.x-ex.x)<=6 and math.abs(item.y-ex.y)<=6 then
            return false
        end
    end

    for k, ID in pairs(module.MustPickID) do
        if item.ID==ID then return true end
    end

    for idx, Type in pairs(module.MustPickType) do
        if item.Type==Type then return true end
    end

    return false
end


local function FindNearestItem(Player,itemlist)


    local left
    local top
    local right
    local bottom

    local target = nil
    local MustLoot= nil

    local dst  = 9999999999
    local dst2 = 9999999999

    local mapBound = GetMapDimension()


    for idx, item in pairs(itemlist) do
        local d = global.Distance(Player.x, Player.y, item.x, item.y)
        local valuable = IsMustLoot(item)
        local inside = ItemInsideMap(item,mapBound.left,mapBound.top,mapBound.right,mapBound.bottom)
        if d < dst and  inside then
            target = item 
            dst = d
        end
        if d < dst2  and valuable and inside then
            MustLoot = item 
            dst2 = d
        end
    end
    return target,MustLoot
end



local function TryLoot(Player, itemlist)
    
    local Looting = false

    if itemlist==nil then return Looting end

     target,MustLoot=FindNearestItem(Player,itemlist)
     -- must loot
     if MustLoot ~=nil then
        Looting=true
        local ms=MoveTo(MustLoot.x, MustLoot.y,2)

        if ms==2 then
            -- print("TryLoot: Uable to find the path")
            Looting=false
        end

        if ms~=2 and math.abs(Player.x-MustLoot.x)<module.Mindis*2 and math.abs(Player.y-MustLoot.y)<module.Mindis*3 then
           
            if LootCount==module.LootAttempts-1 then
                SendKey(module.JumpKey)   --jump
            end
            StopMove()
            SendKey(module.LootKey,4)

            --- check how many attempts made when trying to loot this item
            if global.Distance(MustLoot.x, MustLoot.y, ThisTarget.x, ThisTarget.y)<=6 then
                LootCount=LootCount+1
            else
                LootCount=0
                ThisTarget.x=MustLoot.x
                ThisTarget.y=MustLoot.y
            end

            if LootCount>module.LootAttempts then
                pos={} 
                pos.x=MustLoot.x
                pos.y=MustLoot.y

                if global.length(Exception)==module.ExceptionItemNum then 
                    table.remove(Exception,1)
                end
                table.insert(Exception,pos)
                LootCount=0
            end

        end

     end


    if target ~=nil and module.CasualLoot then
        if math.abs(Player.x-target.x)<module.Mindis*2 and math.abs(Player.y-target.y)<module.Mindis*3 then
            SendKey(module.LootKey,4)
        end
    end

    return Looting
end




function module.Run()

    if module.Enable==false then 
        return
    end


    local Player = GetPlayer();
    local Looting=false
    local itemlist = GetAllDrops()
    
    Looting = TryLoot(Player,itemlist)

    if Looting==true then
        if module.LootStyle==1 then 
            global.IfHunt=false
        else
            global.IfHunt  = true
            global.IngorePathingToMob = true
        end
    else
        global.IfHunt  = true
        global.IngorePathingToMob = false
    end


    return

end

return module