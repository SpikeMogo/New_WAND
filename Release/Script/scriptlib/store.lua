----------------
-- 2022 by Spike

local vk = require('virtualkey')
local global =  require('global')



local function SellPacket(Slot,ID,Num)
	strS = string.format("3D 00 01 %02X 00 ",Slot)
	strI = string.format("%08X",ID)
	strN = string.format("%04X",Num)
	for i=0,3 do
		strS=strS..string.sub(strI,7-i*2,8-i*2).." "
	end
	strS=strS..string.sub(strN,3,4).." "..string.sub(strN,1,2)
  	return strS
end

local function BuyPacket(loc,ID,Num)
	strS = string.format("3D 00 00 %02X 00 ",loc)
	strI = string.format("%08X",ID)
	strN = string.format("%04X",Num)
	for i=0,3 do
		strS=strS..string.sub(strI,7-i*2,8-i*2).." "
	end
	strS=strS..string.sub(strN,3,4).." "..string.sub(strN,1,2)
  	return strS.." 00 00 00 00"
end

local function CheckWhiteList(Type,Item,List)

	if Type=="equip" then
		ID=Item.ID
		local tmp=false
		for i=1, global.length(List) do
			if ID==List[i].ID then
				local tmp2=true
				for j=1, global.length(List[i].Stats)/2 do
					tmp2=tmp2 and Item[List[i].Stats[j*2-1]] >=List[i].Stats[j*2]
				end
				tmp = tmp or tmp2
			end
		end
		return tmp
	end

	if Type=="use" or Type=="etc" then
		ID = Item.ID
		for i=1, global.length(List) do
			if ID==List[i].ID then
				return true
			end
		end
	end
	return false

end

local module = 
{
	IfStore = true,  
	CheckInventoryInterval = 4, 			-- check the equip inventory every 5 min; if the equip is full, go to the store
	StoreMap=100000102,
	NPCLocation = {-213, 182},
	NPCChatKey = vk.VK_SPACE,
	SellWhenEquipsMoreThan=15,
	CCAfterSell= {On = true, RandomCC = false},
	TotalChannel = 3,
	Potion =
	{
		IfBuyPots=true,			
		IfAutoPot=true,
		HpOnKey = vk.VK_DELETE,  	-- only support QuickSlot (8 keys in total)
		MpOnKey = vk.VK_END,		-- only support QuickSlot (8 keys in total)
		FeedDelay=0.2,  			-- Auto pot delay in sec
		AutoHpThreshold=1000,		
		AutoMpThreshold=300,				
		BuyPotionList=
		{
			HP={ID=2000001,BuyNum=600, LowerLimit = 20},
			MP={ID=2000003,BuyNum=500, LowerLimit = 20},
		}
	},
	EquipWhiteList=
	{
		{ID=1302056,Stats={"Watk",103} },
		{ID=1122077,Stats={}},
		{ID=1222222,Stats={"Str", 1,"Dex", 2} },
	},
	UseEtcWhiteList=  -- you need add quest item ID here, because it cannot be sold by packets
	{
		{ID=2030004},
		{ID=2030000},
	},


}

local __LastInventoryCheck  =  os.clock()-1000

function module.Check()

	if module.IfStore==false then return end


	if (os.clock()-__LastInventoryCheck)/60>= module.CheckInventoryInterval and global.IfStore==false then	
		StopMove()
		Delay(100)
		RefreshInventory({"Equip","Use","Etc"})
		Inventory = GetFullInventory({"Equip","Use","Etc"})
		local ne=global.length(Inventory.Equip)
		local nu=global.length(Inventory.Use)
		local nc=global.length(Inventory.Etc)
		
		print(string.format("Inventory Updates: [%d equips], [%d use], [%d etc]",ne, nu, nc))
		if ne>=module.SellWhenEquipsMoreThan then
			print("Need to sell Inventory, go to store")
			global.IfStore=true
			global.IfHunt=false
        	global.IfLoot=false

		end
		__LastInventoryCheck = os.clock()
	end

	if global.IfStore==false and module.Potion.IfBuyPots
		and (NumOnQuickSlot(module.Potion.HpOnKey)<module.Potion.BuyPotionList.HP.LowerLimit
		or   NumOnQuickSlot(module.Potion.MpOnKey)<module.Potion.BuyPotionList.MP.LowerLimit) then
		print("Need to buy Potion, go to store")
		global.IfStore=true
		global.IfHunt=false
        global.IfLoot=false
	end

	return 
end


function module.Sell(Player)


	if global.Distance(Player.x, Player.y, module.NPCLocation[1], module.NPCLocation[2])<20 then
		StopMove()
		Delay(1000)
		RefreshInventory({"Equip","Use","Etc"})
		Inventory = GetFullInventory({"Equip","Use","Etc"})
		
		--open store and close the UI
		
		SendKey(module.NPCChatKey)
		Delay(500)
		InsertBlockPacket({"003D"},"Send")
		SendKey(vk.VK_ESCAPE)
		Delay(500)
		RemoveBlockPacket({"003D"},"Send")
		--

		--sell all equips
		for slot, item in pairs(Inventory.Equip) do
			if CheckWhiteList("equip",item,module.EquipWhiteList)==false then
				SendPacket(SellPacket(slot, item.ID, 1)) Delay(20)
				print("Sell Equip: ", item.Name)
			end
		end
		-- Sell all USE
		for slot, item in pairs(Inventory.Use) do
			if CheckWhiteList("use",item,module.UseEtcWhiteList)==false then
				SendPacket(SellPacket(slot, item.ID, item.Num)) Delay(20)
				print("Sell Use: ", item.Name)
			end
		end
		-- Sell all Etc
		for slot, item in pairs(Inventory.Etc) do
			if CheckWhiteList("etc",item,module.UseEtcWhiteList)==false then
				SendPacket(SellPacket(slot, item.ID, item.Num)) Delay(20)
				print("Sell Etc: ", item.Name)
			end
		end


		--BuyPotions
		if module.Potion.IfBuyPots then 
			-- Buy HP Potion 
			ID =module.Potion.BuyPotionList.HP.ID
			Num=module.Potion.BuyPotionList.HP.BuyNum-NumOnQuickSlot(module.Potion.HpOnKey)
			if Num>0 then
				print(string.format("Buy %d HP Potion, ID=%d",Num,ID))
				Loc=ItemLocationInStore(ID)
				if Loc~=-1 then SendPacket(BuyPacket(Loc,ID,Num)) end
			end
			-- Buy MP Potion 
			ID =module.Potion.BuyPotionList.MP.ID
			Num=module.Potion.BuyPotionList.MP.BuyNum-NumOnQuickSlot(module.Potion.MpOnKey)
			if Num>0 then
				print(string.format("Buy %d MP Potion, ID=%d",Num,ID))
				Loc=ItemLocationInStore(ID)
				if Loc~=-1 then SendPacket(BuyPacket(Loc,ID,Num)) end
			end
		end
		Delay(500)
		SendPacket("3D 00 03")
		print("Send Close Store")
		Delay(1000)

		if module.CCAfterSell.On then
			print("Sell Done, Change Channel")
			local channel = GetChannel()+1
			if  channel>module.TotalChannel then channel = 1 end
			if module.CCAfterSell.RandomCC==true then 
				channel =  GetChannel()
				while  channel ==  GetChannel() do
					channel = math.random(1,module.TotalChannel)
				end
			end
			ChangeChannel(channel)
			Delay(2000)
		end

		global.IfStore=false
		global.IfHunt=true
        global.IfLoot=true


	else
		local ms = MoveTo(module.NPCLocation[1], module.NPCLocation[2])
		if ms==2 then
			print("module.Sell: Uable to find the path")
			StopMove()
		end

	end



	return 
end


return module