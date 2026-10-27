
local function giveInvadeKillItem(monster)
	local itemName = {}
	local rand = math.random()
	if rand < 0.50 then 
		itemName[1] = "poop"
		itemName[2] = "大便"
		itemName[3] = "Shit"
	elseif rand < 0.55 then
		local rand = math.random()
		if rand < 0.7 then 
		itemName[1] = "armormarble"
		else
		itemName[1] = "armorruins"
		end
		itemName[2] = "盔甲"
		itemName[3] = "Armor"
	elseif rand < 0.60 then 
		itemName[1] = "armorslurper"
		itemName[2] = "腰带"
		itemName[3] = "Belt"
	elseif rand < 0.65 then 
		itemName[1] = "ruinshat"
		itemName[2] = "王冠"
		itemName[3] = "Royal Crown"
	elseif rand < 0.70 then 
		itemName[1] = "walrushat"
		itemName[2] = "帽子"
		itemName[3] = "Hat"
	elseif rand < 0.75 then 
		itemName[1] = "sweatervest"
		itemName[2] = "衣服"
		itemName[3] = "Clothes"
	elseif rand < 0.80 then 
		local rand = math.random()
		if rand < 0.2 then
		itemName[1] = "yellowstaff"
		elseif rand < 0.4 then 
		itemName[1] = "telestaff"
		elseif rand < 0.6 then 
		itemName[1] = "orangestaff"
		elseif rand < 0.8 then 
		itemName[1] = "greenstaff"
		else
		itemName[1] = "nightstick"
		end			
		itemName[2] = "法杖"
		itemName[3] = "Staff"
	elseif rand < 0.85 then 
		local rand = math.random()
		if rand < 0.2 then
		itemName[1] = "amulet"
		elseif rand < 0.3 then 
		itemName[1] = "blueamulet"
		elseif rand < 0.5 then 
		itemName[1] = "purpleamulet"
		elseif rand < 0.7 then 
		itemName[1] = "yellowamulet"
		elseif rand < 0.85 then 
		itemName[1] = "greenamulet"
		else
		itemName[1] = "orangeamulet"
		end		
		itemName[2] = "护符"
		itemName[3] = "Amulet"
	elseif rand < 0.90 then 
		itemName[1] = "ruins_bat"
		itemName[2] = "武器"
		itemName[3] = "Weapon"
	elseif rand < 0.97 then 
		itemName[1] = "bandage"
		itemName[2] = "宝药"
		itemName[3] = "Treasure Medicine"
	elseif rand < 0.99 then 
		itemName[1] = "eyeturret_item"
		itemName[2] = "炮台"
		itemName[3] = "Fort"
	else
		itemName[1] = "mandrake"
		itemName[2] = "补肾珍品"
		itemName[3] = "Kidney Nourishing Treasures"
	end
	return itemName
end

local function givePointKillItem(monster)
	local itemName = {}
	local rand = math.random()
	if rand < 0.10 then 
		itemName[1] = "poop"
		itemName[2] = "大便"
		itemName[3] = "Shit"
	elseif rand < 0.2 then
		local rand = math.random()
		if rand < 0.7 then 
		itemName[1] = "armormarble"
		else
		itemName[1] = "armorruins"
		end
		itemName[2] = "盔甲"
		itemName[3] = "Armor"
	elseif rand < 0.3 then 
		itemName[1] = "armorslurper"
		itemName[2] = "腰带"
		itemName[3] = "Belt"
	elseif rand < 0.4 then 
		itemName[1] = "ruinshat"
		itemName[2] = "王冠"
		itemName[3] = "Royal Crown"
	elseif rand < 0.5 then 
		itemName[1] = "walrushat"
		itemName[2] = "帽子"
		itemName[3] = "Hat"
	elseif rand < 0.6 then 
		itemName[1] = "sweatervest"
		itemName[2] = "衣服"
		itemName[3] = "Clothes"
	elseif rand < 0.7 then 
		local rand = math.random()
		if rand < 0.2 then
		itemName[1] = "yellowstaff"
		elseif rand < 0.4 then 
		itemName[1] = "telestaff"
		elseif rand < 0.6 then 
		itemName[1] = "orangestaff"
		elseif rand < 0.8 then 
		itemName[1] = "greenstaff"
		else
		itemName[1] = "nightstick"
		end			
		itemName[2] = "法杖"
		itemName[3] = "Staff"
	elseif rand < 0.8 then 
		local rand = math.random()
		if rand < 0.2 then
		itemName[1] = "amulet"
		elseif rand < 0.3 then 
		itemName[1] = "blueamulet"
		elseif rand < 0.5 then 
		itemName[1] = "purpleamulet"
		elseif rand < 0.7 then 
		itemName[1] = "yellowamulet"
		elseif rand < 0.85 then 
		itemName[1] = "greenamulet"
		else
		itemName[1] = "orangeamulet"
		end		
		itemName[2] = "护符"
		itemName[3] = "Amulet"
	elseif rand < 0.90 then 
		itemName[1] = "bandage"
		itemName[2] = "宝药"
		itemName[3] = "Treasure Medicine"
	elseif rand < 0.95 then 
		itemName[1] = "ruins_bat"
		itemName[2] = "武器"
		itemName[3] = "Weapon"
	elseif rand < 0.98 then 
		itemName[1] = "eyeturret_item"
		itemName[2] = "炮台"
		itemName[3] = "Fort"
	else
		itemName[1] = "mandrake"
		itemName[2] = "补肾珍品"
		itemName[3] = "Kidney Nourishing Treasures"
	end
	return itemName
end

local function getMonsterName(monster)
	local monster_name = ""
	if monster.prefab == "pigman" then
		monster_name = "红色猪皇"
	elseif monster.prefab == "merm" then
		monster_name = "恶魔鱼人王"
	elseif monster.prefab == "bunnyman" then
		monster_name = "恶魔兔人王"
	elseif monster.prefab == "pigguard" then
		if monster:HasTag("little_pig") then
			monster_name = "恶魔野猪弟弟"
		elseif monster:HasTag("big_pig") then
			monster_name = "恶魔野猪哥哥"
		end
	elseif monster.prefab == "rocky" then
		monster_name = "恶魔石虾王"
	elseif monster.prefab == "leif_sparse" then
		monster_name = "恶魔树精长老"
	end
	return monster_name
end

local function handlePointKilled(inst, victim, player)
	
	local monster_name = getMonsterName(victim)
	TheNet:Announce(monster_name.." 已被 "..player.name.." 击杀！！！")
	local item = givePointKillItem(victim.prefab)
	
	inst:DoTaskInTime(10, function()
		if player and player.components.health ~= nil 
		and not player.components.health:IsDead() 
		and player.components.inventory then 
			---SpawnPrefab("lightning")
			player.components.inventory:GiveItem(SpawnPrefab(item[1]))
			TheNet:Announce("恭喜 "..player.name.." 获得了"..monster_name.."的"..item[2].."！！")
		end
	end)

end

--确定怪物被谁杀
local function onKilledOther(inst, victim, player)
	if inst and victim and player then
		if victim:HasTag("pointed_monster_king") then
			handlePointKilled(inst, victim, player)
		end

		if player.components.rp_upgrade then
			player.components.rp_upgrade:killed(player, victim)
		end
		
	end
end

local RP_KilledHandle = Class(function(self, inst)
	self.inst = inst
	self.inst:ListenForEvent("ms_playerjoined", 
		function(src, player)
		self.inst:ListenForEvent( "killed", function(inst,data) onKilledOther(inst, data.victim, player) end, player)	
		end, 
	TheWorld)	
end)

----存储与载入
function RP_KilledHandle:OnSave()
    return
    {
       
    }
end

function RP_KilledHandle:OnLoad(data)
    if data ~= nil and data.time ~= nil then
        
    end
end

return RP_KilledHandle