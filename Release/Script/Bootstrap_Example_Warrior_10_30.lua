----------------
-- 2022 by Spike

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*[/\\])")
end
print("Starting Script")
package.path = script_path().."?.lua;"..script_path().."scriptlib\\".."?.lua"
print("include package path: ", package.path)
math.randomseed(tostring(os.time()):reverse():sub(1, 7))
-- load modules
local vk     = require('virtualkey')
local global = require('global')
local hunt   = require('hunt')
local loot   = require('loot')
local maple  = require('maple')
local store  = require('store')
local walk   = require('walk')


-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------
-----------------------Start from here-----------------------------------------------


-- define your parameters
--------------------------------------------------------------------------------------
 -- game
 --------------------------------------------------------------------------------------
maple.MaxRunTime = 3000   --max run time in minute 
maple.HuntMapList =     -- append hunt map ID, and SafeSpot here
    {
        {ID=100020000,SafeSpot={6, 65}},
        {ID=100030000,SafeSpot={-4096, -63}},
    } 
maple.CCAtSafeSpot = {On = true, RandomCC = true, SwitchMapAfterCC=true}  --CC at SafeSpot
maple.SwitchMapAfterMin = 120 -- switch hunt map after x min, if you have more than one map in HuntMapList
maple.TotalChannel = 20      -- total channel 
--
maple.AlertTimeSec = 20        -- when someone stay in map for more than x sec, go to safespot
maple.PlayerWhiteList = {"myfriend"}        -- player white list, you can put your partner's ign  here
maple.AlertWhenMobAppears = {1234567}       -- alert when some strange mob ID appears 
--
maple.IfMapRushToHunt=false         --use maprush to hunt map
maple.IfMapRushToStore=false        --use maprush to store
maple.MapRushMethod = 0             --maprush method: 0 = spawn control; 1 = packet based; 2 = Use VIP rock 
maple.IfUseScrollToTown=false       -- use return scroll back to town 
ReturnScrollID = 2030000            -- return scroll item ID
------
maple.StopAtLevel = 30              -- stop at level = x
maple.AutoAp = {str=4, dex=1, int =0, luk = 0}  --auto ap
------
maple.Movement=
    {   MaxJump = 80,
        Stepsize = 6,       
        JumpKey = vk.VK_ALT,
        TeleportKey = vk.VK_SHIFT,
        MagicTeleport = false,
        MagicTeleportDistance = 200,
        UsInMapPortal = true,           --if use in_map portal
        TeleportWhenPathFail = true,    -- use teleport hack when path to one point cannot be found
        JumpDownTile= true,             -- jump down tile movement 
    }
------
maple.Buffs =
    {
        IfAutoBuff=false,     
        CanBuffOnRope=true,             -- if you can buff on rope
        ReBuffAdvanceSec = 5,           --rebuff x sec before buff dies
        Buff=
        {
            {ID=1001003, key =vk.VK_T}, 
            {ID=1101006, key =vk.VK_Y},
        }
    }
maple.Filter=
    {
        IfMobFilter=false,
        IfItemFilter=false,
        MobFilter ={1111111,2222222},-- ID of mobs for MobFilter
        ItemFilter={2387002,2387003},-- ID of items for ItemFilter
    }
------
maple.MissGodModeRate = -1  -- rate : x out of 10 will miss, -1 = disable 


--------------------------------------------------------------------------------------
 -- store
 --------------------------------------------------------------------------------------
store.IfStore = true                         -- if go to store
store.CheckInventoryInterval = 4         -- check the equip inventory every 5 min; if the equip is full, go to the store
store.StoreMap=100000102                    
store.NPCLocation = {-351, 224}          --stand close the npc, make sure you can open the NPC chat by key-pressing
store.NPCChatKey = vk.VK_SPACE            
store.SellWhenEquipsMoreThan=55         
store.CCAfterSell= {On = true, RandomCC = false}     
store.Potion =
   {
      IfBuyPots=true,      
      IfAutoPot=true,        
      HpOnKey = vk.VK_DELETE,    -- only support QuickSlot (8 keys in total)
      MpOnKey = vk.VK_END,       -- only support QuickSlot (8 keys in total)
      FeedDelay=0.2,             -- Auto pot delay in sec
      AutoHpThreshold=300,      
      AutoMpThreshold=50,          
      BuyPotionList=
      {
         HP={ID=2000001,BuyNum=600, LowerLimit = 20},  -- go the store if pot is below the LowerLimit
         MP={ID=2000003,BuyNum=500, LowerLimit = 20},
      }
   }
store.EquipWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   {
      {ID=1302056,Stats={"Watk",103} },   -- 
      {ID=1122077,Stats={}},
      {ID=1222222,Stats={"Str", 1,"Dex", 2} },
   }
store.UseEtcWhiteList=  -- you need add nonsalable item ID here, because it cannot be sold by packets
   {
      {ID=2030004},
      {ID=2030000},
   }

--------------------------------------------------------------------------------------
 -- hunt
 --------------------------------------------------------------------------------------
hunt.Keepaway = 
   {
        Front = 0,
        Back = 0,
        Top = 0,
        Bottom = 0,
    }
hunt.Attack =
    {
        HasOrient = true,   
        Key =  vk.VK_CONTROL, --single attack
        Key2 = vk.VK_A, --group attack  
        MobAttack = 1,        -- attack when mobs near you >= x
        MobFind = 1,          -- find mobs in a group of x
        Range = {
            IsFan = false,
            FanMinDistance = 60,
            Front = 80,      -- attack range in front: for spear, probably 120
            Back = 0,        -- attack range: back
            Top = 30,        -- attack range: top
            Bottom = 10,
        },
        count=0
    }
 hunt.YDisReScale = 1       -- rescale the vertical direction in distance calculator , if YDisReScale>1, the bot is prone to transverse movement 


--------------------------------------------------------------------------------------
 -- loot
 --------------------------------------------------------------------------------------
loot.Enable= true  -- enable auto loot function
loot.LootKey=vk.VK_Z    
loot.CasualLoot = true -- loot when you pass by a drop
loot.LootStyle = 2    -- 1 = loot MustPick item immediately, and ignore mobs on the way; 2 = loot MustPick item, but can hunt on the way.
loot.MustPickType =  -- you can put "Mesos", "Equip", "Use", "Setup" "Etc", "Cash", 
    {
        "Equip",
    }
loot.MustPickID =  --  append to this list; must loot this item;
    {
        999999999,
    }
    LootAttempts=10  -- if it takes x attempts to loot one item, give up, and add that location to Exception

-- end of parameters


----------------------------------------------------
--Run the script
maple.Run()
---------------------------------------------------