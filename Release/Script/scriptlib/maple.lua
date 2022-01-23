----------------
-- 2022 by Spike

local hunt = require('hunt')
local loot = require('loot')
local store = require('store')
local walk = require('walk')
local vk = require('virtualkey')
local global =  require('global')



local module = 
{
    -- user defined
    MaxRunTime = 300,
    HuntMapList = 
    {
        {ID=104040000,SafeSpot={-129, -265}},
        {ID=100020000,SafeSpot={-61,  65}},
    }, -- append mapID here
    CCAtSafeSpot = {On = true, RandomCC = false, SwitchMapAfterCC=true},
    SwitchMapAfterMin = 60, --mins
    TotalChannel = 3,
    --
    AlertTimeSec = 20, 
    PlayerWhiteList = {"myfriend"},
    AlertWhenMobAppears = {9999999},
    --
    IfMapRushToHunt=false,
    IfMapRushToStore=false,
    MapRushMethod = 1,
    IfUseScrollToTown=false,
    ReturnScrollID = 2030000,
    --
    StopAtLevel = 60,
    AutoAp = {str=4, dex=1, int =0, luk = 0},
    --
    Movement=
    {   MaxJump = 80,
        Stepsize = 6,       
        JumpKey = vk.VK_ALT,
        TeleportKey = vk.VK_SHIFT,
        MagicTeleport = false,
        MagicTeleportDistance = 200,
        UsInMapPortal = true,
        TeleportWhenPathFail = true,
        JumpDownTile= true,
    },
    --
    Buffs =
    {
        IfAutoBuff=true,
        CanBuffOnRope=false,
        ReBuffAdvanceSec = 5, --rebuff x sec before buff dies
        Buff=
        {
            {ID=1001003, key =vk.VK_T}, 
            {ID=1101006, key =vk.VK_Y},
        }
    },
    Filter=
    {
        IfMobFilter=false,
        IfItemFilter=false,
        MobFilter ={},-- ID of mobs for MobFilter
        ItemFilter={2387002,2387003},-- ID of items for ItemFilter
    },
    --
    MissGodModeRate = -1,  -- rate : x out of 10 will miss, -1 = disable 

}

--local variables
local Starttime = os.clock()
local LastChannel= GetChannel()
local HuntMapIdx = 1
local LastMap
local mymap="NewMap"
local maptimestart
local AlertTime=0
local OldPlayerPos = {x=-1000,y=-1000}
local PeopleHere=false
local OldLevel = 300
local UsedScroll = false
local MissMode = false
local __runtimelast = -20


local __LastMoveTick =  os.clock()
local __LastHpTick   =  os.clock()
local __LastMpTick   =  os.clock()
local __WarningTick  =  os.clock()
local __PlaySoundTick = os.clock()
local __MapStayTick   = os.clock()




local function AutoPotsAndBuff(Player)

    --auto pot
    if store.Potion.IfAutoPot==true then
        if Player.hp<store.Potion.AutoHpThreshold and os.clock()-__LastHpTick>store.Potion.FeedDelay then
            SendKey(store.Potion.HpOnKey) __LastHpTick=os.clock()
        end
        if Player.mp<store.Potion.AutoMpThreshold and os.clock()-__LastMpTick>store.Potion.FeedDelay then
            SendKey(store.Potion.MpOnKey) __LastMpTick=os.clock()
        end
    end

    --check the buffs
    if global.IfHunt==false or module.Buffs.IfAutoBuff==false then return end
    local Buffs = GetBuffandDebuff()
    for i=1,global.length(module.Buffs.Buff) do

        local Found = false
        local time_remain = 10000
        for k, buff in pairs(Buffs.Buff) do
            if buff.ID == module.Buffs.Buff[i].ID then
                time_remain = buff.time_remain
                -- print(buff.ID, "--",time_remain)
                Found = true
            end
        end

        if Found==false or (Found and time_remain<=module.Buffs.ReBuffAdvanceSec) then
            if module.Buffs.CanBuffOnRope==true or Player.OnRope==false then
                SendKey(module.Buffs.Buff[i].key,2)
                print(string.format("Trying to Add Buff, ID = %d",module.Buffs.Buff[i].ID))
                Delay(400)
            end
        end


    end

end

local function UseReturnScroll()

        if UsedScroll then return end
        -- open iven
        RefreshInventory({"Use"})
        Inventory = GetFullInventory({"Use"})
        for slot, use in pairs(Inventory.Use) do
            if use.ID == module.ReturnScrollID then
                str = "55 00 00 00 00 00 "..global.NumToHex(slot, 2)..global.NumToHex(use.ID, 4)
                print("Use return scroll at slot: ",slot, " and ID: ",use.ID)
                SendPacket(str)
                break
            end
        end
        UsedScroll = true
end

local function HuntLootOrShopping(Player)

    -- hunt
    if global.IfHunt then 
        if GetMapID()==module.HuntMapList[HuntMapIdx].ID then
            hunt.Run()
        else
            if module.IfMapRushToHunt then
                MapRush(module.HuntMapList[HuntMapIdx].ID, module.MapRushMethod)
            else
                walk.Walk(Player,module.HuntMapList[HuntMapIdx].ID)
            end
        end
    end

     -- store
    store.Check()
    if global.IfStore then
        if GetMapID()==store.StoreMap then
            store.Sell(Player)
            UsedScroll = false
        else
            if module.IfMapRushToStore then
                MapRush(store.StoreMap, module.MapRushMethod)
            else
                if module.IfUseScrollToTown then
                    UseReturnScroll()
                end
                walk.Walk(Player,store.StoreMap)
            end

        end
    end

    --loot
    if global.IfLoot then
        loot.Run()
    end




end

local function AlertAndHide(Player)

    if global.IfStore then return end
    local people = GetOtherPlayers()
    local count = math.max(global.length(people),GetOtherPlayersCount())

    -- whitelist 
    if people ~=nil then
        for i = 1, global.length(module.PlayerWhiteList) do
            for k, p in pairs(people) do
                if p.name == module.PlayerWhiteList[i] then
                    count = count-1
                    break
                end
            end
        end
    end

    if count>0 then
        if PeopleHere==false then __WarningTick = os.clock() end
        PeopleHere=true
    else
        PeopleHere=false
    end

    --play alert sound
    if AlertTime>0 and os.clock()-__PlaySoundTick>=5 and PeopleHere==true and os.clock()-__WarningTick<AlertTime then
        PlayWav()
        print("Someone is here!!!")
         if people ~=nil then
            str = "People: "
            for k, p in pairs(people) do
                str = str.."["..p.name.."] "
            end
            print(str)
        end
        __PlaySoundTick=os.clock()
    end

    --play alert when strange mobs appear
    local MobUID = GetMobIDinMap()
    local MobAlert = false
    for k, UID in pairs(MobUID) do
        for _, UID2 in pairs(module.AlertWhenMobAppears) do
            if UID==UID2 then MobAlert=true end
        end
    end
    if MobAlert and os.clock()-__PlaySoundTick>=5 then
        PlayWav()
        print("Strange Mob ID!!!")
        __PlaySoundTick=os.clock()
    end



    -- go to safe spot and change channel
    if PeopleHere==true and os.clock()-__WarningTick>AlertTime and GetMapID()==module.HuntMapList[HuntMapIdx].ID then
        global.IfHunt=false
        global.IfLoot=false
        sx = module.HuntMapList[HuntMapIdx].SafeSpot[1]
        sy = module.HuntMapList[HuntMapIdx].SafeSpot[2]
        if(global.Distance(Player.x,Player.y,sx,sy))>walk.Mindis then
            ms=MoveTo(sx,sy)
            print(string.format("Moving to SafeSpot: [%d, %d]..",sx,sy))
            if ms==2 then
                print("Uable to find the path to SafeSpot")
                StopMove()
                global.IfStore=true -- go the store
            end
        else
            StopMove()
            Delay(2000)
            if module.CCAtSafeSpot.On==true then
                print("At SafeSpot, Change Channel")
                local channel = GetChannel()+1
                if  channel>module.TotalChannel then channel = 1 end

                if module.CCAtSafeSpot.RandomCC==true then 
                    channel =  GetChannel()
                    while  channel ==  GetChannel() do
                        channel = math.random(1,module.TotalChannel)
                    end
                end
                ChangeChannel(channel)
                if module.CCAtSafeSpot.SwitchMapAfterCC==true then
                    HuntMapIdx = HuntMapIdx+1
                    if HuntMapIdx>global.length(module.HuntMapList) then HuntMapIdx=1 end
                    print("Switch to HuntMap: ",HuntMapIdx)
                    __MapStayTick = os.clock()
                end
                Delay(3000)
                global.IfHunt=true
                global.IfLoot=true
            else
                print("Stop Script because CCAtSafeSpot is off")
                StopScript()
            end

        end


    end

end

local function DealWithErroneousState(Player)
    
    --player dead
    while(Player.IsDead and Player.hp==0)
    do
        print("....Rise the Dead....")
        locx,locy=FindBMP("OK")
        if(locx~=-1 and locy~=-1) then 
            LeftClickOnWindow(locx,locy)
        end
        Delay(1000)
    end

    -- player stuck
    if OldPlayerPos.x==Player.x and OldPlayerPos.y==Player.y then
            
    else
        __LastMoveTick = os.clock()
    end

    if os.clock()-__LastMoveTick>10 then
        print("===Not moving for a while in hunting====")

        locx,locy=FindBMP("EndChat")
        if(locx~=-1 and locy~=-1) then 
            LeftClickOnWindow(locx,locy)
        end
        -- random jump
        StopMove()
        if math.random(1,2)==1 then 
            HoldKey(vk.VK_LEFT, 1)
        else 
            HoldKey(vk.VK_RIGHT, 1)
        end
        Delay(300) 
        SendKey(vk.VK_ALT)
        Delay(300) 
    end
    OldPlayerPos.x=Player.x
    OldPlayerPos.y=Player.y
end

local function CheckMapOwnership()
    AlertTime=0
    if LastChannel==GetChannel() and LastMap==GetMapID() then
        if mymap=="NewMap" then maptimestart=os.clock() end
        mymap="OwnedMap"

        if os.clock()-maptimestart>60 then AlertTime = module.AlertTimeSec end
    else
        mymap="NewMap" 
        maptimestart=os.clock()
    end
    LastChannel=GetChannel()
    LastMap=GetMapID()
   

    if (os.clock()-__MapStayTick)/60>=module.SwitchMapAfterMin then
        HuntMapIdx = HuntMapIdx+1
        if HuntMapIdx>global.length(module.HuntMapList) then HuntMapIdx=1 end
        print("Switch to HuntMap: ",HuntMapIdx)
        __MapStayTick = os.clock()
    end

    local runtime=(os.clock()-Starttime)/60
    if runtime-__runtimelast>10 then
        print("Script Run Time: ",math.floor(runtime)," mins")
        __runtimelast=runtime
    end

end


local function InitialSetup()

    --Set Map Data
    SetMapData(module.Movement.MaxJump,       module.Movement.Stepsize, module.Movement.JumpKey, module.Movement.TeleportKey, 
               module.Movement.MagicTeleportDistance, module.Movement.MagicTeleport, module.Movement.UsInMapPortal,module.Movement.TeleportWhenPathFail,module.Movement.JumpDownTile)
    
    -- setup
    SetMobFilter(module.Filter.MobFilter,  module.Filter.IfMobFilter)
    SetItemFilter(module.Filter.ItemFilter,module.Filter.IfItemFilter)
    

    
    store.TotalChannel = module.TotalChannel
    loot.JumpKey = module.Movement.JumpKey
    walk.NPCChatKey = store.NPCChatKey
    table.insert(store.UseEtcWhiteList,store.Potion.BuyPotionList.HP)
    table.insert(store.UseEtcWhiteList,store.Potion.BuyPotionList.MP)
    table.insert(store.UseEtcWhiteList,{ID=module.ReturnScrollID})

    --print buffs
    local Buffs = GetBuffandDebuff()
    for k,buff in pairs(Buffs.Buff) do
        print("Current Buff:",buff.ID)
    end

end


local function OnLevelChange(Player)
        --------------------------------------------------
        -- Level
        --------------------------------------------------
        if Player.level >= module.StopAtLevel then
            print(string.format("Level %d Reached, Stop....",module.StopAtLevel))
            StopScript()
        end

        if Player.level>OldLevel then 
            print("Adding Ap")
            AssignAP(module.AutoAp.str, module.AutoAp.dex, module.AutoAp.int, module.AutoAp.luk)
        end
        OldLevel = Player.level
end

local function OnHacks()
    local p = math.random(1,10)

    if p<module.MissGodModeRate then
        if MissMode==false then EnableHacks({31}) MissMode=true end 
    else
        if MissMode==true then DisableHacks({31}) MissMode=false end 
    end
    -- body
end

function module.Run()

    InitialSetup()

    --start the loop
    while( (os.clock()-Starttime)/60<module.MaxRunTime )
    do
        Player = GetPlayer()

        OnHacks()

        CheckMapOwnership()

        OnLevelChange(Player)

        DealWithErroneousState(Player)

        AlertAndHide(Player)

        AutoPotsAndBuff(Player)

        HuntLootOrShopping(Player)


        --end of loop
        Delay(10)
    end



end

return module