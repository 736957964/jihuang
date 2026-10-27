local _G = GLOBAL
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TUNING = _G.TUNING

local equip_up = GetModConfigData("equip_up")

if equip_up and IsServer then
weighted_random_choice = GLOBAL.weighted_random_choice
Remap = GLOBAL.Remap
ACTIONS = GLOBAL.ACTIONS
TheSim = GLOBAL.TheSim
CreateEntity = GLOBAL.CreateEntity

------------------------------------------------------------------武器类------------------------------------------------------------------

--weapon(武器代码)  fix(对应修复材料)  adduses(基础修复耐久值)  base(基础战斗力，战斗力只是根据武器属性做出的一个评分，决定武器回复耐久度
local weapon = {
"spear",
"spear_wathgrithr",
"ruins_bat",
"boomerang",
"tentaclespike",
"nightsword",
"icestaff",
"firestaff",
"cane",
"orangestaff",
"hambat",
"whip",
"bsd",
"hnd",
"hnq"
}
local weaponlist = {
{weapon = "spear",fix = "flint",adduses = 50,base = 10},--长矛对应燧石
{weapon = "spear",fix = "twigs",adduses = 20,base = 10},--长矛对应树枝
{weapon = "spear_wathgrithr",fix = "goldnugget",adduses = 35,base = 15},--战斗长矛对应金块
{weapon = "spear_wathgrithr",fix = "flint",adduses = 35,base = 15},--战斗长矛对应燧石
{weapon = "ruins_bat",fix = "thulecite",adduses = 30,base = 30},--铥矿棒对应铥矿
{weapon = "ruins_bat",fix = "thulecite_pieces",adduses = 5,base = 30},--铥矿棒对应铥矿碎片
{weapon = "ruins_bat",fix = "livinglog",adduses = 30,base = 30},--铥矿棒对应活木
{weapon = "ruins_bat",fix = "nightmarefuel",adduses = 20,base = 30},--铥矿棒对应噩梦燃料
{weapon = "boomerang",fix = "charcoal",adduses = 5,base = 10},--回旋镖对应木炭
{weapon = "boomerang",fix = "silk",adduses = 5,base = 10},--回旋镖对应蜘蛛网
{weapon = "boomerang",fix = "boards",adduses = 6,base = 10},--回旋镖对应木板
{weapon = "tentaclespike",fix = "tentaclespots",adduses = 100,base = 18},--触手尖刺对应触手皮
{weapon = "tentaclespike",fix = "houndstooth",adduses = 30,base = 18},--触手尖刺对应狗牙
{weapon = "nightsword",fix = "nightmarefuel",adduses = 20,base = 28},--影刀对应噩梦燃料
{weapon = "nightsword",fix = "livinglog",adduses = 30,base = 28},--影刀对应活木
{weapon = "nightsword",fix = "shadowheart",adduses = 100,base = 28},--影刀对应暗影心脏
{weapon = "icestaff",fix = "thulecite_pieces",adduses = 8,base = 20},--冰魔杖对应的铥矿碎片
{weapon = "firestaff",fix = "thulecite_pieces",adduses = 8,base = 20},--火魔杖对应的铥矿碎片
{weapon = "cane",fix = "walrus_tusk",adduses = 50,base = 15},--手杖海象牙修
{weapon = "orangestaff",fix = "walrus_tusk",adduses = 15,base = 20},--懒惰的探索者对应海象牙
{weapon = "orangestaff",fix = "livinglog",adduses = 5,base = 20},--懒惰的探索者对应活木
{weapon = "hambat",fix = "meat",adduses = 0.1,base = 25},--肉棒对应大肉
{weapon = "hambat",fix = "ice",adduses = 0.4,base = 25},--肉棒对应冰块
{weapon = "hambat",fix = "pigskin",adduses = 0.2,base = 25},--肉棒对应猪皮
{weapon = "whip",fix = "tentaclespots",adduses = 30,base = 15},--鞭子对应触手皮
{weapon = "whip",fix = "coontail",adduses = 40,base = 15},--鞭子对应猫尾巴
{weapon = "bsd",fix = "gears",adduses = 100,base = 30},--大宝剑对应齿轮
{weapon = "bsd",fix = "goldnugget",adduses = 20,base = 30},--大宝剑对应金子
{weapon = "hnd",fix = "bluegem",adduses = 100,base = 30},
{weapon = "hnd",fix = "nightmarefuel",adduses = 20,base = 30},
{weapon = "hnq",fix = "redgem",adduses = 100,base = 30},
{weapon = "hnq",fix = "nightmarefuel",adduses = 20,base = 30},
}

local function calculateweapon(weapon)--计算战斗力
	for i,v in ipairs(weaponlist) do
		if v.weapon == weapon.prefab then
			weapon.base = v.base
		end
	end
	weapon.base = weapon.base or 0
	if weapon.level ~= nil then 
		weapon.level.bluegem = weapon.level.bluegem or 0
		weapon.level.redgem = weapon.level.redgem or 0
		weapon.level.purplegem = weapon.level.purplegem or 0
		weapon.level.orangegem = weapon.level.orangegem or 0
		weapon.level.yellowgem = weapon.level.yellowgem or 0
		weapon.level.greengem = weapon.level.greengem or 0
	end
	local num = weapon.base + weapon.level.bluegem * 3 + weapon.level.redgem * 3 + weapon.level.purplegem * 3 + weapon.level.orangegem * 4 + weapon.level.yellowgem * 4 + weapon.level.greengem * 4 + (weapon.infinite and 36 or 0)
	return num,num - weapon.base
end

local function fixweapon(weapon,fixer,giver)--材料武器不对应损坏武器(剩余耐久的1/3)，修复材料消失，否则根据武器战斗力计算修复耐久次数
	for i,v in ipairs(weaponlist) do
		if v.weapon == weapon.prefab and fixer.prefab == v.fix then
			_, weapon.ability = calculateweapon(weapon)
			if weapon.components.finiteuses then
				local adduses = math.ceil(math.clamp(v.adduses * (1 - 0.005 * weapon.ability) , v.adduses * 0.28 , v.adduses * 1))
				if weapon.components.finiteuses.total - weapon.components.finiteuses.current <= adduses then 
					weapon.components.finiteuses:SetUses(weapon.components.finiteuses.total)
					giver.components.talker:Say("修复成功,耐久已回复至满")
				else weapon.components.finiteuses:SetUses(weapon.components.finiteuses.current + adduses)
					giver.components.talker:Say("修复成功,耐久回复" ..tostring(adduses) .."次")
				end
			end
			if weapon.components.perishable then
				local adduses = math.clamp(v.adduses * (1 - 0.00633 * weapon.ability) , 0.005 , 0.4)
				if (1 - weapon.components.perishable:GetPercent()) <= adduses then 
					weapon.components.perishable:SetPercent(1)
					giver.components.talker:Say("修复成功,保鲜度已回复至满")
				else weapon.components.perishable:SetPercent(weapon.components.perishable:GetPercent() + adduses)
					giver.components.talker:Say("修复成功,保鲜度回复" ..string.format("%.2f",adduses * 100) .."%")
				end
			end
			return
		end
	end
	if weapon.components.finiteuses then
		local loseuses = math.floor(weapon.components.finiteuses.current/3)
		weapon.components.finiteuses:SetUses(weapon.components.finiteuses.current - loseuses)
		giver.components.talker:Say("修复失败,修复材料有误,耐久损失" ..tostring(loseuses) .."次")
	end
	if weapon.components.perishable then
		local loseuses = weapon.components.perishable:GetPercent() * 0.25
		weapon.components.perishable:SetPercent(weapon.components.perishable:GetPercent() - loseuses)
		giver.components.talker:Say("修复失败,修复材料有误,保鲜度损失" ..string.format("%.2f",loseuses * 100) .."%")
	end
end

--火腿棒重新计算攻击力
local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER*TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_DAMAGE)
		if inst.level then
			inst.level.greengem = inst.level.greengem or 0
		end
        inst.components.weapon:SetDamage(dmg + inst.level.greengem * 2)
    end
end

local weapon_test = function(inst,item,giver)
	if item.prefab == "moonrocknugget" or item.prefab == "fossil_piece" or item.prefab == "opalpreciousgem" then
	local moonrocknuggetuses = inst.moonrocknuggetuses or 0
	local fossil_piece_time = inst.fossil_piece_time or 0
	local opalpreciousgem_time = inst.opalpreciousgem_time or 0
	if moonrocknuggetuses > 0 or fossil_piece_time > 0 or opalpreciousgem_time > 0 then
		if giver.components.talker then
			giver.components.talker:Say("只能同时激活一种效果!")
		end
		return false
	end
	end
	if item.components.armor or item.components.weapon or item.components.finiteuses or item.components.fueled then
		if giver.components.talker then
			giver.components.talker:Say("开玩笑，这样怎么可以呢!")
		end
		return false
	end
	return true
end

local function convert_weapon(weapon,item)
	weapon.luck = weapon.luck or 0
	local random_bluegem = {
	--蓝宝石随机附出的属性
		bluegem = 10,
		redgem = 5,
		purplegem = 3,
		orangegem = 1,
		yellowgem = 1,
		greengem = 1,
		lose = 0,
	}
	local random_redgem = {
	--红宝石随机附出的属性
		bluegem = 5,
		redgem = 10,
		purplegem = 3,
		orangegem = 1,
		yellowgem = 1,
		greengem = 1,
		lose = 0,
	}
	local random_purplegem = {
	--紫宝石随机附出的属性
		bluegem = 5,
		redgem = 5,
		purplegem = 7,
		orangegem = 1,
		yellowgem = 1,
		greengem = 1,
		lose = 0,
	}
	local random_yellowgem = {
	--黄宝石随机附出的属性
		bluegem = 1,
		redgem = 1,
		purplegem = 1,
		orangegem = 2,
		yellowgem = 3,
		greengem = 2,
		lose = 0,
	}
	local random_orangegem = {
	--橙宝石随机附出的属性
		bluegem = 1,
		redgem = 1,
		purplegem = 1,
		orangegem = 3,
		yellowgem = 2,
		greengem = 2,
		lose = 0,
	}
	local random_moonrocknugget = {
	--月石随机附出的属性
		moonrocknugget = 6,
		fossil_piece = 3,
		opalpreciousgem = 1,
	}
	local random_fossil_piece = {
	--化石随机附出的属性
		moonrocknugget = 3,
		fossil_piece = 6,
		opalpreciousgem = 1,
	}
	local random_opalpreciousgem = {
	--闪闪发光的宝石随机附出的属性
		moonrocknugget = 1,
		fossil_piece = 1,
		opalpreciousgem = 8,
	}
	if item.prefab == "bluegem" then
		return weighted_random_choice(random_bluegem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "redgem" then
		return weighted_random_choice(random_redgem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "purplegem" then
		return weighted_random_choice(random_purplegem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "yellowgem" then
		return weighted_random_choice(random_yellowgem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "orangegem" then
		return weighted_random_choice(random_orangegem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "moonrocknugget" then
		return weighted_random_choice(random_moonrocknugget),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "fossil_piece" then
		return weighted_random_choice(random_fossil_piece),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
	if item.prefab == "opalpreciousgem" then
		return weighted_random_choice(random_opalpreciousgem),math.clamp(math.ceil(math.random(weapon.luck*2 - 5,weapon.luck*2 + 5)), 1, 25)
	end
end

local function clear(inst)
	material={
	"bluegem",
	"redgem",
	"purplegem",
	"greengem",
	"yellowgem",
	"orangegem",
	}
	local list = {}
	for i,v in pairs(material) do
		inst.level[v] = inst.level[v] or 0
		if inst.level[v] > 0 then
			table.insert(list ,v)
		end
	end
	local n = math.clamp(math.ceil(math.random(0,#list)),1,#list)
	inst.level[(list[n])] = 0
end

local function name_weapon(inst)
	inst.originalname = inst.originalname or inst.name
	inst.moonrocknuggetstring = inst.moonrocknuggetuses and "\n" .."『魔法』已激活 剩余" ..tostring(inst.moonrocknuggetuses) .."次" or ""
	inst.luck = inst.luck or 0
	inst.luckstring = inst.luck > 0 and "\n" .."幸运 " ..tostring(inst.luck) or ""
	inst.fossil_piece_string = inst.fossil_piece_time and "\n" .."『石化』已激活 剩余" ..tostring(inst.fossil_piece_time) .."秒" or ""
	inst.opalpreciousgemstring = inst.opalpreciousgem_time and "\n" .."『盛气』已激活 剩余" ..tostring(inst.opalpreciousgem_time) .."秒" or ""
	inst.level.bluegem = inst.level.bluegem or 0
	inst.level.redgem = inst.level.redgem or 0
	inst.level.purplegem = inst.level.purplegem or 0
	inst.level.yellowgem = inst.level.yellowgem or 0
	inst.level.orangegem = inst.level.orangegem or 0
	inst.level.greengem = inst.level.greengem or 0
	inst.bluegemstring = inst.level.bluegem > 0 and "\n" .."冰霜附加 " ..tostring(inst.level.bluegem) or ""
	inst.redgemstring = inst.level.redgem > 0 and "\n" .."毒性附加 " ..tostring(inst.level.redgem) or ""
	inst.purplegemstring = inst.level.purplegem > 0 and "\n" .."闪电附加 " ..tostring(inst.level.purplegem) or ""
	inst.orangegemstring = inst.level.orangegem > 0 and "\n" .."移速附加 " ..tostring(inst.level.orangegem) or ""
	inst.yellowgemstring = inst.level.yellowgem > 0 and "\n" .."嗜血附加 " ..tostring(inst.level.yellowgem) or ""
	inst.greengemstring = inst.level.greengem > 0 and "\n" .."伤害附加 " ..tostring(inst.level.greengem) or ""
	inst.abilitystring = "\n" .."综合战力 " ..tostring(calculateweapon(inst))
	inst.infinitestring = inst.infinite and "\n----无尽----" or ""
	inst.components.named:SetName(inst.originalname .. inst.bluegemstring .. inst.redgemstring .. inst.purplegemstring .. inst.yellowgemstring .. inst.orangegemstring .. inst.greengemstring .. inst.moonrocknuggetstring .. inst.fossil_piece_string .. inst.opalpreciousgemstring .. inst.luckstring .. inst.infinitestring .. inst.abilitystring)
end

--给予武器物品时更改物品相应等级,执行相应操作
local function levelup_weapon(inst,giver,item)
	if item.prefab == "greengem" then
		local num = math.random()
		if num <= 0.3 then inst.luck = 1;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.5 then inst.luck = 2;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.65 then inst.luck = 3;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.77 then inst.luck = 4;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.86 then inst.luck = 5;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.92 then inst.luck = 6;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.95 then inst.luck = 7;if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
elseif num <= 0.979 then inst.luck = 8;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了幸运值为8的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
elseif num <= 0.989 then inst.luck = 9;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了幸运值为9的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck)) end
elseif num <= 0.999 then inst.luck = 10;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了满幸运值的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("武器获得幸运值 " ..tostring(inst.luck) .."幸运值上限0.0") end
		else
			if giver.components.talker then
				giver.components.talker:Say("这把武器看起来不能再用了，或许我可以换把武器再试试!")
				TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .."撞上了小偷包的概率!")
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:SetUses(0)
			else
				inst:Remove()
			end
			return
		end
	end
	if item.prefab == "bluegem" or item.prefab == "redgem" or item.prefab == "purplegem" or item.prefab == "yellowgem" or item.prefab == "orangegem" or item.prefab == "moonrocknugget" or item.prefab == "fossil_piece" or item.prefab == "opalpreciousgem" then
		local a,b = convert_weapon(inst,item)
		if a == "lose" and giver.components.talker then
			giver.components.talker:Say("这把武器看起来不能再用了，或许我可以换把武器再试试!")
			TheNet:Announce("玩家" .. giver:GetDisplayName() .. "摧毁了一把" .. (inst.originalname or inst:GetDisplayName()))
			if inst.components.finiteuses then
				inst.components.finiteuses:SetUses(0)
			else
				inst:Remove()
			end
			return
		end
		item.prefab = a
		inst.uplevel = b
		material={
		"bluegem",
		"redgem",
		"purplegem",
		"greengem",
		"yellowgem",
		"orangegem",
		}
		stringupgrade={
		["bluegem"]="获取冰霜属性 ",
		["redgem"]="获取毒性属性 ",
		["purplegem"]="获取闪电属性 ",
		["greengem"]="获取增伤属性 ",
		["yellowgem"]="获取嗜血属性 ",
		["orangegem"]="获取迅捷属性 ",
		}
		inst.level= inst.level or {}
		maxlevel = 25
		local num = 0
		for i,v in pairs(material) do
		inst.level[v] = inst.level[v] or 0
		if inst.level[v] > 0 then
			num = num + 1
		end
		inst.level[v] = math.min(inst.level[v], maxlevel)
		end
		if item.prefab ~= "moonrocknugget" and item.prefab ~= "fossil_piece" and item.prefab ~= "opalpreciousgem" then
			inst.luck = 0
			inst.becleared = false
			if num >=3 then
				if inst.level[item.prefab] == 0 then
					clear(inst)
					inst.becleared = true
				end
			end
			inst.level[item.prefab] = math.min(inst.uplevel,25)
			if giver.components.talker then
				stringclear = inst.becleared and "但同时好像失去了一些东西" or ""
				giver.components.talker:Say(stringupgrade[item.prefab] ..tostring(inst.uplevel) ..stringclear)
				if inst.uplevel > 3 then
				TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "的" .. (inst.originalname or inst:GetDisplayName()) .. stringupgrade[item.prefab] ..tostring(inst.uplevel))
				end
			end
		end
	else
		if item.prefab ~= "greengem" then
			fixweapon(inst,item,giver)
		end
	end
		if inst.renamed == false then
			inst.originalname = inst.name
			inst.renamed = true
		end
		if item.prefab == "greengem" and inst.prefab ~= "hambat" then
			if inst.redamage == false then
				inst.redamage = true
				inst.originaldamage = inst.components.weapon.damage or 10
			end
			inst.level.greengem = inst.level.greengem or 0
			inst.components.weapon:SetDamage(inst.originaldamage + inst.level.greengem*2)
		end

		if item.prefab == "orangegem" then
			if inst.respeed == false then
				inst.respeed = true
				inst.originalspeed = inst.components.equippable.walkspeedmult or 1.0
			end
			inst.components.equippable.walkspeedmult = inst.originalspeed + inst.level.orangegem*0.02
		end

		if item.prefab == "fossil_piece" then
			inst.fossil_piece_aroused = true
			inst.fossil_piece_time = 100
			if inst.fossil_piece_aroused == true then
				inst.checkfossil = inst:DoPeriodicTask(1,function()
					if inst.fossil_piece_time and inst.fossil_piece_time > 0 then
					inst.fossil_piece_time = inst.fossil_piece_time - 1
					name_weapon(inst)
					else inst.fossil_piece_aroused = false
					inst.fossil_piece_time = nil
					name_weapon(inst)
					if inst.checkfossil then
						inst.checkfossil:Cancel()
						inst.checkfossil = nil
					end
					end
				end)
			end
		end
		if item.prefab == "moonrocknugget" then
			inst.moonrocknuggetuses = (inst.moonrocknuggetuses) and (inst.moonrocknuggetuses + 3) or 3
			if inst.components.equippable:IsEquipped() then
				inst.components.weapon:SetRange(12)
			end
		end
		if item.prefab == "opalpreciousgem" then
			local x,y,z = giver.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z,25)
			for i,v in pairs(ents) do 
				if v.components.combat and not v:HasTag("player") then
					if v.components.combat.target == giver then
					v.components.combat.target = nil
					end
				end
			end
			inst.opalpreciousgem_aroused = true	
			inst.opalpreciousgem_time = 60
			if inst.opalpreciousgem_aroused == true then
				inst.checkopal = inst:DoPeriodicTask(1,function()
					if inst.opalpreciousgem_time and inst.opalpreciousgem_time > 0 then
					inst.opalpreciousgem_time = inst.opalpreciousgem_time - 1
					name_weapon(inst)
					else inst.opalpreciousgem_aroused = false
					inst.opalpreciousgem_time = nil
					name_weapon(inst)
					if inst.checkopal then
						inst.checkopal:Cancel()
						inst.checkopal = nil
					end
					end
				end)
			end
			if inst.components.equippable:IsEquipped() then
				--local x,y,z = giver.Transform:GetWorldPosition()
				--local ents = TheSim.FindEntities(x,y,z,20)
				
				if inst.opalpreciousgem_aroused == true then
					inst.originalsanity = inst.components.equippable.dapperness or 0
					inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL + inst.originalsanity
					if inst._light == nil or not inst._light:IsValid() then
					inst._light = GLOBAL.SpawnPrefab("yellowamuletlight")
					--inst._light.Transform:SetScale(25,25,25)
					--inst._light.AnimState:SetMultColour(1,0,0,1)
					end
					inst._light.entity:SetParent(giver.entity)
					inst._lightremove = inst._light:DoTaskInTime((inst.opalpreciousgem_time or 0),function() 
										inst._light:Remove()
										inst._light = nil
										inst.components.equippable.dapperness = inst.originalsanity or inst.components.equippable.dapperness
										end)

				end
			end
		end
		if inst.prefab == "hambat" then
			UpdateDamage(inst)
		end
	name_weapon(inst)
end

--辅助函数
local function OnDeath(inst)
    if inst.components.lootdropper and inst:IsValid() then
		inst:RemoveComponent("lootdropper")
		inst:AddComponent("lootdropper")
		inst.components.lootdropper.loot = {}
		for i = 1,math.random(2,4) do table.insert(inst.components.lootdropper.loot,"cutstone") end
		inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 
    end
	if inst.components.playercontroller then
		inst.components.playercontroller:Enable(true)
	end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

--保存武器数据
local function OnSave(inst,data)
	if inst.oldonsave ~= nil then
		inst.oldonsave(inst,data)
	end
	if inst.level ~= nil then
	data.level = {}
    data.level = inst.level
	data.moonrocknuggetuses = inst.moonrocknuggetuses or nil
	end
	data.oldrange = inst.oldrange or nil
	if inst.luck ~= nil then
	data.luck = inst.luck
	end
	data.originalname = inst.originalname or nil
	data.originaldamage = inst.originaldamage or nil
	data.originalspeed = inst.originalspeed or nil
	data.renamed = inst.renamed
	if inst.fossil_piece_aroused == true then
	data.fossil_piece_aroused = true
	data.fossil_piece_time = inst.fossil_piece_time or 0
	end
	if inst.opalpreciousgem_aroused == true then
	data.opalpreciousgem_aroused = true
	data.opalpreciousgem_time = inst.opalpreciousgem_time or 0
	end
	data.infinite = inst.infinite
end

--加载武器数据
local function OnLoad(inst,data)
	if inst.oldonload ~= nil then
		inst.oldonload(inst,data)
	end
	if data ~= nil and inst:IsValid() then
		if data.luck ~= nil then
			inst.luck = data.luck
		end
		inst.infinite = data.infinite
		if inst.infinite then
			if inst.components.finiteuses then
				inst:RemoveComponent("finiteuses")
			end
			if inst.components.perishable then
				inst:RemoveComponent("perishable")
			end
		end
		inst.oldrange = data.oldrange
		if data.level ~= nil then 
		inst.level = {}
		inst.level = data.level
		inst.moonrocknuggetuses = data.moonrocknuggetuses or nil
		end
		if data.renamed then 
			inst.renamed = true 
			inst.originalname = data.originalname
			if inst.level ~= nil then
			name_weapon(inst)
			end
		end
		if data.originaldamage and inst.prefab ~= "hambat" then
			inst.redamage = true
			inst.originaldamage = data.originaldamage
			inst.level.greengem = inst.level.greengem or 0
			inst.components.weapon:SetDamage(inst.originaldamage + inst.level.greengem*2)
		end	
		if data.originalspeed then
			inst.respeed = true
			inst.originalspeed = data.originalspeed
			inst.components.equippable.walkspeedmult = inst.originalspeed + inst.level.orangegem*0.02
		end	
		if data.fossil_piece_aroused == true then
			inst.fossil_piece_aroused = true
			inst.fossil_piece_time = data.fossil_piece_time or 0
			if inst.fossil_piece_aroused == true then
				inst.checkfossil = inst:DoPeriodicTask(1,function()
					if inst.fossil_piece_time and inst.fossil_piece_time > 0 then
					inst.fossil_piece_time = inst.fossil_piece_time - 1
					name_weapon(inst)
					else inst.fossil_piece_aroused = false
					inst.fossil_piece_time = nil
					name_weapon(inst)
					if inst.checkfossil then
						inst.checkfossil:Cancel()
						inst.checkfossil = nil
					end
					end
				end)
			end
		end
		
		if data.opalpreciousgem_aroused == true then
			inst.opalpreciousgem_aroused = true	
			inst.opalpreciousgem_time = data.opalpreciousgem_time or 0
			if inst.opalpreciousgem_aroused == true then
				inst.checkopal = inst:DoPeriodicTask(1,function()
					if inst.opalpreciousgem_time and inst.opalpreciousgem_time > 0 then
					inst.opalpreciousgem_time = inst.opalpreciousgem_time - 1
					name_weapon(inst)
					else inst.opalpreciousgem_aroused = false
					inst.opalpreciousgem_time = nil
					name_weapon(inst)
					if inst.checkopal then
						inst.checkopal:Cancel()
						inst.checkopal = nil
					end
					end
				end)
			end
		end
	end
end

--武器攻击时执行等级效果
local function onattack(inst,owner,target)
	if target:HasTag("wall") or target.prefab == "eyeturret" then
		return
	end
	if inst.prefab == "hambat" then
		UpdateDamage(inst)
	end
	if inst.level ~= nil then 
		if inst.level.bluegem ~= 0 and inst.level.bluegem then
			if math.random() <= inst.level.bluegem * 0.02 * 0.8 then
				if target.components.freezable then
					target.components.freezable:AddColdness(0.2*inst.level.bluegem, 0.4*inst.level.bluegem)
					target.components.freezable:SpawnShatterFX()
				end
				if target.components.burnable then
					if target.components.burnable:IsBurning() then
					target.components.burnable:Extinguish()
					if target.components.freezable then
					target.components.freezable:SpawnShatterFX()
					end
					end
				end
			end
		end
		
		if inst.level.redgem ~= 0 and inst.level.redgem then
			if math.random() <= inst.level.redgem*0.02 then
				local fx = GLOBAL.SpawnPrefab("maxwell_smoke")
				fx.Transform:SetPosition(target.Transform:GetWorldPosition())
				local x,y,z = target.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z,2.5)
				for i,v in pairs(ents) do
				if v.babydata == nil then
				if v ~= owner and v:HasTag("player") and TheNet:GetPVPEnabled() and v.components.health and v.AnimState then
					local armor = v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
					local multiplier = 1
					if armor then
					if armor.level and type(armor.level) == "table" then
						if armor.level.insulate then
							multiplier = 1 - armor.level.insulate * 0.04
						end
					end
					end
					v.regentime = (v.regentime or 0) + 0.4*inst.level.redgem
					if v.regentask == nil then
					v.regentask = v:DoPeriodicTask( 1,function()
					if not v.components.health:IsDead() then
						multiplier = multiplier or 1
						v.components.health:DoDelta(-3 * multiplier)
					end
					v.regentime = v.regentime and (v.regentime - 1) or 0
					if v.regentime < 0 or v.components.health:IsDead() then 
						if v.regentask then
							v.regentask:Cancel()
							v.regentask = nil
						end
						v.AnimState:SetMultColour(1 , 1 , 1 , 1)
						v.regentime = nil
					end
					end)
					end
					v.AnimState:SetMultColour(0 , 0.8 , 0 , 0.7)
				end
				if v.components.health and v.AnimState then
				if v.components.health and v.components.health.maxhealth<=2500 and not v:HasTag("wall") and not v:HasTag("player") and v ~= owner then
					v.regentime = (v.regentime or 0) + 0.4*inst.level.redgem
					if v.regentask == nil then
					v.regentask = v:DoPeriodicTask( 1,function()
					if not v.components.health:IsDead() then
						v.components.health:DoDelta(-10)
					end
					v.regentime = v.regentime and (v.regentime - 1) or 0
					if v.regentime < 0 then 
						if v.regentask then
							v.regentask:Cancel()
							v.regentask = nil
						end
						v.AnimState:SetMultColour(1 , 1 , 1 , 1)
						v.regentime = nil
					end
					end)
					end
					v.AnimState:SetMultColour(0 , 0.8 , 0 , 0.7)
					if v.components.combat and not v:HasTag("player") and not v.prefab == "eyeturret" then
						v.components.combat.target = owner
					end
				end
				end
				end
				end
			end			
		end
		
		if inst.level.purplegem ~= 0 and inst.level.purplegem then
			if math.random() <= inst.level.purplegem*0.012 then
				local num = math.floor(inst.level.purplegem*0.21)
				for i=1,num do
				GLOBAL.SpawnPrefab("lightning").Transform:SetPosition(target.Transform:GetWorldPosition())
				end
				if target.components.health and not target:HasTag("player") then
					target.components.health:DoDelta(-24*num)
				end
				if target:HasTag("player") and TheNet:GetPVPEnabled() then
					if not target.components.inventory:IsInsulated() then
						target.components.health:DoDelta(target.prefab == "wx78" and 24 * num or -8*num)
						target.sg:GoToState("electrocute")
					end
				end
			end			
		end
		
		if inst.level.yellowgem ~= 0 and inst.level.yellowgem and target.components.health then
			if math.random() <= inst.level.yellowgem * 0.02 then
				local num = (target.components.combat.defaultdamage or 0) * 2 * 0.25/(target.components.health.maxhealth/inst.components.weapon.damage)
				owner.components.health:DoDelta(num * 1.5)
				if owner.prefab == "wathgrithr" and owner.components.sanity ~= nil then 
				owner.components.sanity:DoDelta(num * 1.5)
				end
			end
		end
	end
	
	if inst.moonrocknuggetuses then
		inst.moonrocknuggetuses = inst.moonrocknuggetuses - 1
		if inst.moonrocknuggetuses == 0 then
			inst.components.weapon:SetRange(inst.oldrange or nil)
			inst.moonrocknuggetuses = nil
		end
		name_weapon(inst)
		local x,y,z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,4)
		local num = 0
		owner.components.combat:DoAreaAttack(target, 4, inst, nil, nil, {"player"})
		for i,v in pairs(ents) do 
		if v:HasTag("player") and v ~= owner and TheNet:GetPVPEnabled() then
			if not v.components.inventory:IsInsulated() then
				v.components.health:DoDelta(v.prefab == "wx78" and 30 or -15)
				v.sg:GoToState("electrocute")
			end
		end
		if v.components.health and not v:HasTag("player") then
		num = num + 1
		local x,y,z = v.Transform:GetWorldPosition()
		GLOBAL.SpawnPrefab("lightning").Transform:SetPosition(x,y,z)
		end
		end
		if owner.components.sanity then
		owner.components.sanity:DoDelta(-num*3)
		end
		if math.random() <= 0.33 then
			if math.random() <= 0.5 then
			spell = GLOBAL.SpawnPrefab("deer_ice_circle")
			spell.Transform:SetPosition(x, 0, z)
			spell:DoTaskInTime(6, spell.KillFX)
			else
			spell = GLOBAL.SpawnPrefab("deer_fire_circle")
			spell.Transform:SetPosition(x, 0, z)
			spell:DoTaskInTime(4, spell.KillFX)
			end
		end
	end
	if inst.fossil_piece_aroused == true and inst.fossil_piece_arousedwait == true then
		owner.components.talker:Say("武器在石化cd中!")
	end
	if inst.fossil_piece_aroused == true and inst.fossil_piece_arousedwait == false then
		if math.random() <= 0.5 then 
			inst.fossil_piece_arousedwait = true
			owner.components.talker:Say("它现在无法动弹!但是它拥有更高的防御力!")
			local x,y,z = target.Transform:GetWorldPosition()
			local fx1 = GLOBAL.SpawnPrefab("statue_transition_2")
			if fx1 ~= nil then
				fx1.Transform:SetPosition(x, y, z)
				fx1.Transform:SetScale(1, 2, 1)
			end

			local fx2 = GLOBAL.SpawnPrefab("statue_transition")
			if fx2 ~= nil then
				fx2.Transform:SetPosition(x, y, z)
				fx2.Transform:SetScale(1, 1.5, 1)
			end
			if target.sg and target.sg.sg and target.sg.sg.states.hit and target.components.health then
				if target.components.health and not target.components.health:IsDead() then 
				target.sg:GoToState("hit")
				end
			end
			if target.brain then
				target.brain:Stop()
			end
			if target.sg then
				target.sg:Stop()
			end
			if target.components.playercontroller then
				target.components.health.minhealth = 1
				target.components.playercontroller:Enable(false)
			end
			target.AnimState:SetMultColour(100/255, 100/255, 100/255, 1)
			target:ListenForEvent("death", OnDeath)
			if target.components.health then 
				target.originalabsorb = target.components.health.absorb or 0
				target.components.health.absorb = 1 - (1 - (target.components.health.absorb or 0))* 0.5
			end
			target:DoTaskInTime((target:HasTag("player") and 3 or 8), function()
			local fx1 = GLOBAL.SpawnPrefab("statue_transition_2")
			if fx1 ~= nil then
				fx1.Transform:SetPosition(x, y, z)
				fx1.Transform:SetScale(1, 2, 1)
			end

			local fx2 = GLOBAL.SpawnPrefab("statue_transition")
			if fx2 ~= nil then
				fx2.Transform:SetPosition(x, y, z)
				fx2.Transform:SetScale(1, 1.5, 1)
			end
			if target.components.health then
				target.components.health.absorb = target.originalabsorb
			end
			target.AnimState:SetMultColour(1, 1, 1, 1)
			target:RemoveEventCallback("death", OnDeath)
			if target.brain then
				target.brain:Start()
			end
			if target.sg then
				target.sg:Start()
				if target.sg and target.sg.sg.states.idle then
					target.sg:GoToState("idle")
				end
			end
			if target:HasTag("player") then
				target.AnimState:PlayAnimation("idle")
			end
			if target.components.playercontroller then
				target.components.health.minhealth = 0
				target.components.playercontroller:Enable(true)
			end
			end)
			target:DoTaskInTime(9,function()
				if target:IsValid() then
					if target.components.health then
						if target.components.health.currenthealth == 0 then
							target:Remove()
						end
					end
				else
					target:Remove()
				end
			end)
			inst:DoTaskInTime(20,function()
									inst.fossil_piece_arousedwait = false
									if inst.fossil_piece_aroused == true then
									owner.components.talker:Say("武器石化cd冷却完毕!")
									end
								end)
		end
	end
	if inst.opalpreciousgem_aroused == true then
		if math.random()<= 0.33  and target:IsValid() then 
	    local tornado = GLOBAL.SpawnPrefab("tornado")
			tornado.WINDSTAFF_CASTER = owner
			tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
			tornado.Transform:SetPosition(getspawnlocation(inst, target))
			tornado.components.knownlocations:RememberLocation("target", target:GetPosition())
			if inst.level then
				tornado.AnimState:SetMultColour(inst.level.redgem/25,inst.level.purplegem/25,inst.level.bluegem/25,0.5)
				if inst.level.bluegem >= 10 then
				tornado:ListenForEvent("onhitother", function(inst, data)
										local other = data.target
											if math.random() <=0.33 then
											if other and other.components.freezable then
													other.components.freezable:AddColdness(2)
													other.components.freezable:SpawnShatterFX()
											end
											end
										end)
				end
				if inst.level.redgem >= 10 then
					tornado:ListenForEvent("onhitother" , function(inst,data)
							local other = data.target
							if other and other.components.burnable and not other:HasTag("player") then	
								other.components.burnable:Ignite(true, tornado)
							end
							if other:HasTag("player") and other ~= owner and TheNet:GetPVPEnabled() then	
								other.components.burnable:Ignite(true, tornado)
							end
							end)
				end
				if inst.level.purplegem >= 10 then
					tornado:ListenForEvent("onhitother", function(inst,data)
					local other = data.target
						if other and other.components.health and not other:HasTag("player") then
								if math.random() <= 0.25 then
								local fx = GLOBAL.SpawnPrefab("lightning")
								local x,y,z = other.Transform:GetWorldPosition()
								fx.Transform:SetPosition(x,y,z)
								if other.components.health and not other:HasTag("player") then
									other.components.health:DoDelta(-10)
								end
							end
						end
						if other:HasTag("player") and TheNet:GetPVPEnabled() then	
							if not other.components.inventory:IsInsulated() then
								other.components.health:DoDelta(other.prefab == wx78 and 6 or -3 )
								other.sg:GoToState("electrocute")
							end
						end
					
					end)
				end
			end
		end
	end
	if inst.oldonattack then
		inst.oldonattack(inst,owner,target)
	end	
end

--部分升级需要在装备穿在身上才有效
local function onequip(inst,owner)
	if inst.oldonequip then
		inst.oldonequip(inst,owner)
	end
	if inst.prefab == "hambat" then
		UpdateDamage(inst)
	end
	if inst.moonrocknuggetuses then
	inst.components.weapon:SetRange(12)
	end
	if inst.opalpreciousgem_aroused == true then
		inst.originalsanity = inst.components.equippable.dapperness or 0
		inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL + inst.originalsanity
		if inst._light == nil or not inst._light:IsValid() then
			inst._light = GLOBAL.SpawnPrefab("yellowamuletlight")
			--inst._light.Transform:SetScale(25,25,25)
			--inst._light.AnimState:SetMultColour(1,0,0,1)
		end
		inst._light.entity:SetParent(owner.entity)
		inst._lightremove = inst._light:DoTaskInTime((inst.opalpreciousgem_time or 0),function() 
												inst._light:Remove()
												inst._light = nil
												inst.components.equippable.dapperness = inst.originalsanity or inst.components.equippable.dapperness
												end)
	end
			
end

local function onunequip(inst,owner)
	if inst.oldonunequip then
		inst.oldonunequip(inst,owner)
	end
	if inst.prefab == "hambat" then
		UpdateDamage(inst)
	end
	inst.components.weapon:SetRange(inst.oldrange or nil)
	inst.components.equippable.dapperness = inst.originalsanity or inst.components.equippable.dapperness
	if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
	if inst._lightremove ~= nil then
	inst._lightremove:Cancel()
	inst._lightremove = nil
	end
end


--将要调用的函数存入武器代码中
for i, v in ipairs(weapon) do
	AddPrefabPostInit(v,function(inst)
		inst.level = inst.level or {}
		if inst.components.named == nil then
			inst:AddComponent("named")
			inst.oldName = inst.name
		end
		inst.renamed = false

		
		inst.redamage = false
		inst.respeed = false
		inst.fossil_piece_aroused = false
		inst.fossil_piece_arousedwait = false
		
		inst.opalpreciousgem_aroused = false
		
		if inst.components.weapon == nil then
		    inst:AddComponent("weapon")
			inst.components.weapon:SetDamage(10)
		end
		
		if inst.prefab == "hambat" then
			inst.components.weapon:SetOnAttack(UpdateDamage)
		end
		
		inst.oldrange = inst.components.weapon.attackrange
		if inst.prefab == "cane" then --手杖设置200次耐久
			inst:AddComponent("finiteuses")
			inst.components.finiteuses:SetMaxUses(200)
			inst.components.finiteuses:SetUses(200)
			inst.components.finiteuses:SetOnFinished(inst.Remove)
		end
		
		inst.oldonsave = inst.OnSave
		inst.OnSave = OnSave
		inst.oldonload = inst.OnLoad
		inst.OnLoad = OnLoad
		
		inst.oldonequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(onequip)
		inst.oldonunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(onunequip)
		
		
		inst.oldonattack = inst.components.weapon.onattack
		inst.components.weapon.onattack = onattack
		
		if inst.components.trader == nil then
		inst:AddComponent("trader")
		end
		inst.components.trader.onaccept = levelup_weapon
		inst.components.trader:SetAcceptTest(weapon_test)
		
		inst.infinite = false
	end)
end

--幸运值影响战利品掉落

AddComponentPostInit("lootdropper", function(LootDropper, inst)
LootDropper.olddroploot = LootDropper.DropLoot
function LootDropper:DropLoot(pt)
if LootDropper.olddroploot and inst:IsValid() then
LootDropper:olddroploot(pt)
end
if inst.babydata == nil and inst:IsValid() then
local x,y,z = inst.Transform:GetWorldPosition()
local ents = TheSim:FindEntities(x,y,z,5)
local luck = 0
local num = 0
for i,v in pairs(ents) do
	if v:HasTag("player") then
		local weapon = v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		num = num + 1
		if weapon then
		weapon.luck = weapon.luck or 0
		luck = weapon.luck + luck
		end
	end
end
for i,v in pairs(ents) do
	if v:HasTag("player") then
		local armor = v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		num = num + 1
		if armor then
			armor.luck = armor.luck or 0
			luck = armor.luck + luck
		end
	end
end
for i,v in pairs(ents) do
	if v:HasTag("player") then
		local helmet = v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
		num = num + 1
		if helmet then
			helmet.luck = helmet.luck or 0
			luck = helmet.luck + luck
		end
	end
end
local n = (luck/num) * 0.4
local add = 0
if n <= 1 then
	if math.random() < n then
		add = 1
	end
elseif n <= 2 then
	if math.random() < n - 1 then
		add = 2
	else
		add = 1
	end
elseif n <= 3 then
	if math.random() < n - 2 then
		add = 3
	else
		add = 2
	end
elseif n <= 4 then
	if math.random() < n - 3 then
		add = 4
	else
		add = 3
	end
end
prefabs = LootDropper:GenerateLoot()
if #prefabs > 5 then
	for i = 1,add do
		LootDropper:SpawnLootPrefab(prefabs[math.ceil(math.clamp(math.random(0, #prefabs) ,1,#prefabs))], pt)
	end
else
	if math.random() <= add * #prefabs * 0.1 then
		LootDropper:SpawnLootPrefab(prefabs[math.ceil(math.clamp(math.random(0, #prefabs) ,1,#prefabs))], pt)
	end
end
end
		
end
end) 
--部分物品原版无法给予
for i,v in ipairs(weaponlist) do
AddPrefabPostInit(v.fix,function(inst)
	if inst.components.tradable == nil then
	inst:AddComponent("tradable")
	end
end)
end


------------------------------------------------------------------防具类------------------------------------------------------------------


--prefab防具代码 health原版防具血量 type防具种类 fix防具可供修复的材料列表 base防具基础战力
local defendlist = {
{prefab = "armorgrass", health = 157.5 , type = "armor" ,fix = {cutgrass = 20,twigs = 20} ,base = 10},--草甲对应草，树枝
{prefab = "armorwood", health = 315 , type = "armor" ,fix = {rope = 60,log = 30} ,base = 15},--木甲对应绳子，木头
{prefab = "armor_sanity", health = 525 , type = "armor" ,fix = {papyrus = 150,nightmarefuel = 120,shadowheart = 300} ,base = 25},--影甲对应纸，噩梦燃料，暗影心脏
{prefab = "armormarble", health = 735 , type = "armor" ,fix = {rope = 50,marble = 100} ,base = 22},--大理石护甲对应绳子，大理石
{prefab = "armorsnurtleshell", health = 735 , type = "armor" ,fix = {slurtleslime = 120,slurtle_shellpieces = 240} ,base = 20},--蜗牛壳对应蜗牛粘液和碎壳
{prefab = "armorruins", health = 1260 , type = "armor" ,fix = {thulecite = 180,thulecite_pieces = 35,nightmarefuel = 75} ,base = 30},--铥矿甲对应铥矿，铥矿碎片，噩梦燃料
{prefab = "armordragonfly", health = 945 , type = "armor" ,fix = {dragon_scales = 300,pigskin = 100,log = 50} ,base = 22},--火甲对应火蜻蜓鳞片，猪皮，木头
{prefab = "wathgrithrhat", health = 525 , type = "helmet" ,fix = {goldnugget = 100,rocks = 100} ,base = 20},--战斗头盔对应石头，金子
{prefab = "slurtlehat", health = 525 , type = "helmet" ,fix = {slurtleslime = 120,slurtle_shellpieces = 200} ,base = 25},--蜗牛头盔对应蜗牛壳，蜗牛粘液
{prefab = "beehat", health = 1050 , type = "helmet" ,fix = {silk = 120,rope = 80} ,base = 15},--养蜂人的帽子对应蜘蛛网和绳子
{prefab = "footballhat", health = 315 , type = "helmet" ,fix = {pigskin = 100,rope = 50} ,base = 18},--猪皮帽对应猪皮，绳子
{prefab = "ruinshat", health = 840 , type = "helmet" ,fix = {thulecite = 150,thulecite_pieces = 35,nightmarefuel = 60} ,base = 30},--铥矿皇冠对应铥矿，铥矿碎片，噩梦燃料
{prefab = "hivehat", health = 945 , type = "helmet" ,fix = {honeycomb = 300,royal_jelly = 300,honey = 50} ,base = 20},--蜂后帽子对应蜂巢，蜂王浆，蜂蜜

}

local type_helmet = {"hot","sleep","insulate","escape","live","finite","attack",}
local type_armor = {"cold","freeze","fire","moisture","dodge","escape","live","finite","attack",}

local function identify(inst)--鉴别防具种类
	for i,v in ipairs(defendlist) do
		if v.prefab == inst.prefab then
			return v.type
		end
	end
	assert(false)
end

local function identifyintable(table,value)
	for i,v in ipairs(table) do 
		if v == value then
			return true
		end
	end
	return false
end

local function identifynum(inst)--鉴别防具已经具有的属性数量
	local num = 0
	local type = identify(inst)
	if type == "helmet" then
		for i,v in ipairs(type_helmet) do
			if inst.level[v] ~= 0 and inst.level[v] then
				num = num + 1
			end
		end
	end
	if type == "armor" then
		for i,v in ipairs(type_armor) do
			if inst.level[v] ~= 0 and inst.level[v] then
				num = num + 1
			end
		end
	end
	return num,abilitylist
end

local function identifylist(inst)
	local abilitylist = {}
	local disabilitylist = {}
	local type = identify(inst)
	if type == "helmet" then
		for i,v in ipairs(type_helmet) do
			if inst.level[v] ~= 0 and inst.level[v] then
				table.insert(abilitylist,v)
			else
				table.insert(disabilitylist,v)
			end
		end
	end
	if type == "armor" then
		for i,v in ipairs(type_armor) do
			if inst.level[v] ~= 0 and inst.level[v] then
				table.insert(abilitylist,v)
			else
				table.insert(disabilitylist,v)
			end
		end
	end
	return abilitylist,disabilitylist
end

local function calculatedefend(inst)
	local type = identify(inst)
	local base = 0
	inst.luck = inst.luck or 0
	for i,v in ipairs(defendlist) do
		if inst.prefab == v.prefab then
			base = v.base
		end
	end
	if type == "helmet" then
		for i,v in ipairs(type_helmet) do
			inst.level[v] = inst.level[v] or 0
		end
		local n = inst.level.hot * 2 + inst.level.sleep * 3 + inst.level.insulate * 2 + inst.level.escape * 3 + inst.level.live * 2 + inst.level.finite * 3 + inst.level.attack * 3 + inst.luck * 3 + (inst.infinite and 100 or 0)
		return  n + base ,n
	end
	if type == "armor" then
		for i,v in ipairs(type_armor) do
			inst.level[v] = inst.level[v] or 0
		end
		local n = inst.level.cold * 2 + inst.level.freeze * 3 + inst.level.fire * 3 + inst.level.moisture * 2 + inst.level.dodge * 3 + inst.level.escape * 3 + inst.level.live * 2 + inst.level.finite * 3 + inst.level.attack * 3 + inst.luck * 3 + (inst.infinite and 100 or 0)
		return  n + base ,n
	end
end


local function name_defend(inst)
	inst.originalname = inst.originalname or inst.name
	inst.luck = inst.luck or 0
	inst.luckstring = inst.luck > 0 and "\n" .."幸运 " ..tostring(inst.luck) or ""
	inst.infinitestring = inst.infinite and "\n" .. "----无尽----" or ""
	local type = identify(inst)
	if type == "helmet" then
		for i,v in ipairs(type_helmet) do
			inst.level[v] = inst.level[v] or 0
		end
		inst.hotstring = inst.level.hot > 0 and "\n" .."炎热抗性 " ..tostring(inst.level.hot) or ""
		inst.sleepstring = inst.level.sleep > 0 and "\n" .."睡眠抗性 " ..tostring(inst.level.sleep) or ""
		inst.insulatestring = inst.level.insulate > 0 and "\n" .."绝缘附加 " ..tostring(inst.level.insulate) or ""
	end
	if type == "armor" then
		for i,v in ipairs(type_armor) do
			inst.level[v] = inst.level[v] or 0
		end	
		inst.coldstring = inst.level.cold > 0 and "\n" .."寒冷抗性 " ..tostring(inst.level.cold) or ""
		inst.freezestring = inst.level.freeze > 0 and "\n" .."冻结抗性 " ..tostring(inst.level.freeze) or ""
		inst.firestring = inst.level.fire > 0 and "\n" .."火焰抗性 " ..tostring(inst.level.fire) or ""
		inst.moisturestring = inst.level.moisture > 0 and "\n" .."潮湿抗性 " ..tostring(inst.level.moisture) or ""
		inst.dodgestring = inst.level.dodge > 0 and "\n" .."闪避附加 " ..tostring(inst.level.dodge) or ""
	end
	inst.escapestring = inst.level.escape > 0 and "\n" .."逃逸附加 " ..tostring(inst.level.escape) or ""
	inst.livestring = inst.level.live > 0 and "\n" .."免死附加 " ..tostring(inst.level.live) or ""
	inst.finitestring = inst.level.finite > 0 and "\n" .."耐久附加 " ..tostring(inst.level.finite) or ""
	inst.attackstring = inst.level.attack > 0 and "\n" .."反伤附加 " ..tostring(inst.level.attack) or ""
	inst.abilitystring = "\n" .."综合战力 " ..tostring(calculatedefend(inst))
	if type == "helmet" then
		inst.components.named:SetName(inst.originalname .. inst.hotstring .. inst.sleepstring .. inst.insulatestring .. inst.escapestring .. inst.livestring .. inst.finitestring .. inst.attackstring .. inst.luckstring .. inst.infinitestring .. inst.abilitystring)
	end
	if type == "armor" then
		inst.components.named:SetName(inst.originalname .. inst.coldstring .. inst.freezestring .. inst.firestring .. inst.moisturestring .. inst.dodgestring .. inst.escapestring .. inst.livestring .. inst.finitestring .. inst.attackstring .. inst.luckstring .. inst.infinitestring .. inst.abilitystring)
	end
end


local function convert_defend(inst, item)
	inst.luck = inst.luck or 0
	local type = identify(inst)
	local random_bluegem = {}
	local random_redgem = {}
	local random_purplegem = {}
	local random_orangegem = {}
	local random_yellowgem = {}
	if type == "helmet" then
		random_bluegem = {
		hot = 10,
		sleep = 5,
		insulate = 5,
		escape = 1,
		live = 1,
		finite = 1,
		attack = 1,
		}
		random_redgem = {
		hot = 4,
		sleep = 5,
		insulate = 8,
		escape = 1,
		live = 2,
		finite = 1,
		attack = 2,
		}
		random_purplegem = {
		hot = 2,
		sleep = 8,
		insulate = 2,
		escape = 4,
		live = 1,
		finite = 1,
		attack = 1,
		}
		random_yellowgem = {
		hot = 2,
		sleep = 2,
		insulate = 2,
		escape = 1,
		live = 2,
		finite = 6,
		attack = 2,
		}
		random_orangegem = {
		hot = 2,
		sleep = 2,
		insulate = 2,
		escape = 6,
		live = 4,
		finite = 2,
		attack = 2,
		}
	end
	if type == "armor" then
		random_bluegem = {
		cold = 3,
		freeze = 3,
		fire = 10,
		moisture = 2,
		dodge = 3,--闪避
		escape = 2,
		live = 1,
		finite = 1,
		attack = 1,
		}
		random_redgem = {
		cold = 8,
		freeze = 8,
		fire = 3,
		moisture = 5,
		dodge = 3,--闪避
		escape = 2,
		live = 1,
		finite = 1,
		attack = 1,
		}
		random_purplegem = {
		cold = 2,
		freeze = 2,
		fire = 2,
		moisture = 2,
		dodge = 4,--闪避
		escape = 4,
		live = 3,
		finite = 1,
		attack = 1,
		}
		random_yellowgem = {
		cold = 2,
		freeze = 2,
		fire = 2,
		moisture = 2,
		dodge = 1,--闪避
		escape = 1,
		live = 3,
		finite = 8,
		attack = 3,
		}
		random_orangegem = {
		cold = 2,
		freeze = 2,
		fire = 2,
		moisture = 2,
		dodge = 5,--闪避
		escape = 5,
		live = 5,
		finite = 2,
		attack = 2,
		}
	end
	local random_level = {--与幸运值无关	
	}
	for i = 97,1,-4 do 
		table.insert(random_level,i)
	end
	if item.prefab == "bluegem" then
		return weighted_random_choice(random_bluegem),weighted_random_choice(random_level)
	end
	if item.prefab == "redgem" then
		return weighted_random_choice(random_redgem),weighted_random_choice(random_level)
	end
	if item.prefab == "purplegem" then
		return weighted_random_choice(random_purplegem),weighted_random_choice(random_level)
	end
	if item.prefab == "yellowgem" then
		return weighted_random_choice(random_yellowgem),weighted_random_choice(random_level)
	end
	if item.prefab == "orangegem" then
		return weighted_random_choice(random_orangegem),weighted_random_choice(random_level)
	end
end

local function defend_test(inst,item,giver)
if item.prefab == "moonrocknugget" or item.prefab == "fossil_piece" or item.prefab == "opalpreciousgem" then
	if giver.components.talker then
		giver.components.talker:Say("暂未开放此功能，敬请期待!")
	end
	return false
end
if item.components.armor or item.components.weapon or item.components.finiteuses or item.components.fueled then
	if giver.components.talker then
		giver.components.talker:Say("开玩笑，这样怎么可以呢!")
	end
	return false
end

return true
end

local function fixdefend(inst,fixer,giver)
	inst.luck = inst.luck or 0
	local _ ,ability = calculatedefend(inst)
	ability = ability or 0
	for i,v in ipairs(defendlist) do
		if v.prefab == inst.prefab then
			local adduses = 0
			for k , finite in pairs(v.fix) do
				if k == fixer.prefab then
					adduses = finite
				end
			end
			if adduses ~= 0 then
			local extra = 0.1 * math.random(inst.luck * 20 - 50,inst.luck * 20 + 50)
			local multiplier = extra * 0.01 + math.clamp(1 - 0.00533 * ability , 0.2 , 1.2)
			local adduses = adduses * multiplier
			local oldcondition = inst.components.armor.condition or 100
			if adduses + oldcondition >= inst.components.armor.maxcondition then
				inst.components.armor:SetPercent(1)
				if giver.components.talker then
					giver.components.talker:Say("防具耐久已回复至满!")
				end
			else
				inst.components.armor:SetCondition(adduses + oldcondition)
				if giver.components.talker then
					if extra > 0 then
						giver.components.talker:Say("防具回复耐久" .. string.format("%.1f",adduses) .. ",运气真好，多回复了" .. string.format("%.1f",adduses * extra * 0.01) .. "点耐久")
					else
						giver.components.talker:Say("防具回复耐久" .. string.format("%.1f",adduses) .. ",真倒霉啊，少回复了" .. string.format("%.1f",- adduses * extra * 0.01) .. "点耐久")
					end
				end
			end
			return
			end
		end
	end
	if inst.components.armor then
		local loseuses = inst.components.armor.condition/3
		inst.components.armor:SetCondition(inst.components.armor.condition - loseuses)
		if giver.components.talker then
			giver.components.talker:Say("修复失败,修复材料有误,防具血量损失" ..tostring(math.floor(loseuses)))
		end
	end
end

local function defend_getstring(feature)
	if feature == "hot" then return "『炎热抗性』" 
	elseif feature == "sleep" then return "『睡眠抗性』" 
	elseif feature == "insulate" then return "『绝缘附加』" 
	elseif feature == "cold" then return "『寒冷抗性』" 
	elseif feature == "freeze" then return "『冰冻抗性』" 
	elseif feature == "fire" then return "『火焰抗性』" 
	elseif feature == "moisture" then return "『潮湿抗性』" 
	elseif feature == "dodge" then return "『闪避附加』" 
	elseif feature == "escape" then return "『逃逸附加』" 
	elseif feature == "live" then return "『免死附加』" 
	elseif feature == "finite" then return "『耐磨附加』" 
	elseif feature == "attack" then return "『反伤附加』" 
	else return "未知属性" end
end

local function levelup_defend(inst,giver,item)
	inst.luck = inst.luck or 0
	if item.prefab == "greengem" then
		local num = math.random()
		if num <= 0.3 then inst.luck = 1;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.5 then inst.luck = 2;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.65 then inst.luck = 3;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.77 then inst.luck = 4;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.86 then inst.luck = 5;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.92 then inst.luck = 6;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.95 then inst.luck = 7;if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.975 then inst.luck = 8;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了幸运值为8的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.985 then inst.luck = 9;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了幸运值为9的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck)) end
		elseif num <= 0.99 then inst.luck = 10;TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .. "获取了满幸运值的" .. (inst.originalname or inst:GetDisplayName()));if giver.components.talker then giver.components.talker:Say("防具获得幸运值 " ..tostring(inst.luck) .."幸运值上限0.0") end
		else
			if giver.components.talker then
				giver.components.talker:Say("这个防具已经被弄坏了，我不想再穿它了!")
				TheNet:Announce("恭喜玩家" .. giver:GetDisplayName() .."撞上了小偷包的概率!")
			end
			if inst.components.armor then
				inst.components.armor:SetPercent(0)
			else
				inst:Remove()
			end
		end
	end
	local feature,uplevel
	if item.prefab == "bluegem" or item.prefab == "redgem" or item.prefab == "purplegem" or item.prefab == "yellowgem" or item.prefab == "orangegem" then
		local num = identifynum(inst)
		local type = identify(inst)
		local abilitylist,disabilitylist = identifylist(inst)
		if type == "helmet" then
			for i,v in ipairs(type_helmet) do
				inst.level[v] = inst.level[v] or 0
			end
			if num == 0 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				end
			elseif num == 1 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.35 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.5 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 2 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.08 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.1 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 3 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.016 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.02 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 4 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			end
		elseif type == "armor" then
			for i,v in ipairs(type_armor) do
				inst.level[v] = inst.level[v] or 0
			end
			if num == 0 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				end
			elseif num == 1 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.50 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.66 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 2 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.15 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.20 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 3 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				elseif n < 0.075 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.10 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 4 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
				elseif n < 0.015 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(disabilitylist,feature)
					inst.level[feature] = uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】获取新属性" .. defend_getstring(feature) .. "等级" .. tostring(uplevel))
					end
				elseif n < 0.02 then
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel + inst.level[feature] > 25) and (25 - inst.level[feature]) or uplevel
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
						TheNet:Announce(giver:GetDisplayName() .. "的【" .. (inst.originalname or inst:GetDisplayName()) .. "】属性" .. defend_getstring(feature) .. "等级提升" .. tostring(uplevel))
					end
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			elseif num == 5 then
				local n = math.random(0,1000)/1000
				if n < 0.05 - 0.005*inst.luck then
					if giver.components.talker then
						giver.components.talker:Say("我特么又整坏了一个防具！( ╯□╰ )")
						TheNet:Announce(giver:GetDisplayName() .. "整坏了一件【" .. (inst.originalname or inst:GetDisplayName()) .. "】")
					end
					inst:Remove()
				else
					repeat	feature,uplevel = convert_defend(inst,item)		
					until identifyintable(abilitylist,feature)
					uplevel = (uplevel > inst.level[feature]) and (- inst.level[feature]) or (- uplevel)
					inst.level[feature] = inst.level[feature] + uplevel
					if giver.components.talker then
						giver.components.talker:Say("防具属性" .. defend_getstring(feature) .. "等级下降" .. tostring(-uplevel))
					end
				end
			end
		else
			assert(false,"未找到与该防具匹配的种类")
		end
	else
		if item.prefab ~= "greengem" then
			fixdefend(inst,item,giver)
		end
	end
	if feature == "hot" then
		if inst.level.hot > 0 then
			if inst.components.insulator == nil then
				inst:AddComponent("insulator")
			end
			inst.components.insulator:SetInsulation(10 * inst.level.hot)
			inst.components.insulator:SetSummer()
		else
			if inst.components.insulator then
				inst:RemoveComponent("insulator")
			end
		end
	end
	if feature == "sleep" then
		inst.addsleep = (inst.addsleep or 0) + uplevel
        if giver.components.sleeper ~= nil and inst.components.inventoryitem ~= nil then
			if inst.components.equippable:IsEquipped() and inst.components.inventoryitem:IsHeldBy(giver) then
				giver.components.sleeper.resistance = giver.components.sleeper.resistance + uplevel * 2.5
			end
        elseif giver.components.grogginess ~= nil and inst.components.inventoryitem ~= nil then
			if inst.components.equippable:IsEquipped() and inst.components.inventoryitem:IsHeldBy(giver) then
				giver.components.grogginess.resistance = giver.components.grogginess.resistance + uplevel * 2.5
			end
        end
	end
	if feature == "insulate" then
		if inst.level.insulate > 15 then
			inst.components.equippable.insulated = true
		else
			inst.components.equippable.insulated = false
		end
	end
	if feature == "cold" then
		if inst.level.cold > 0 then
			if inst.components.insulator == nil then
				inst:AddComponent("insulator")
			end
			inst.components.insulator:SetInsulation(10 * inst.level.cold)
			inst.components.insulator:SetWinter()
		else
			if inst.components.insulator then
				inst:RemoveComponent("insulator")
			end
		end
	end
	if feature == "freeze" then
		inst.addfreeze = (inst.addfreeze or 0) + uplevel
        if giver.components.freezable ~= nil and inst.components.inventoryitem ~= nil then
			if inst.components.equippable:IsEquipped() and inst.components.inventoryitem:IsHeldBy(giver) then
				giver.components.freezable.resistance = giver.components.freezable.resistance + uplevel * 0.4
			end
        end
	end
	if feature == "fire" then
		inst.addfire = (inst.addfire or 0) + uplevel
        if giver.components.health ~= nil and inst.components.inventoryitem ~= nil then
			if inst.components.equippable:IsEquipped() and inst.components.inventoryitem:IsHeldBy(giver) then
				giver.components.health.fire_damage_scale = giver.components.health.fire_damage_scale - uplevel * 0.04
			end
        end
	end
	if feature == "moisture" then
		if inst.level.moisture > 0 then
			if inst.keepdry == false then
				inst.keepdry = true
			end
			if not inst:HasTag("waterproofer") then
				inst:AddTag("waterproofer")
			end
			if inst.components.waterproofer == nil then
				inst:AddComponent("waterproofer")
			end
			inst.components.waterproofer:SetEffectiveness(0.04 * inst.level.moisture)
		else
			if inst.components.waterproofer then
				inst.components.waterproofer:SetEffectiveness(0)
			end
		end
	end
	if feature == "finite" then
		if inst.components.armor then
			local oldpercent = inst.components.armor:GetPercent()
			local addpercent = inst.level.finite * 0.06
			if inst.oldcondition == nil then
				inst.oldcondition = inst.components.armor.maxcondition
			end
			inst.components.armor.maxcondition = (addpercent + 1) * inst.oldcondition
			inst.components.armor:SetPercent(oldpercent)
		end
	end
	if inst.renamed == false then
		inst.originalname = inst.name
		inst.renamed = true
	end
	name_defend(inst)
	return
end

local function calculatedistance(inst1,inst2)
	local x1,y1,z1 = inst1.Transform:GetWorldPosition()
	local x2,y2,z2 = inst2.Transform:GetWorldPosition()
	return math.sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2) + (z1-z2) * (z1-z2))
end

local function MakeArmorInfinite(inst)
	if inst.components.armor then
		inst.components.armor.maxcondition = 100000--防止伤害过高一次性打炸护甲
		inst.components.armor:SetPercent(1)
	end
	inst:ListenForEvent("percentusedchange",function(inst,data)	
		if inst.components.armor and data.percent < 1 then
			inst.components.armor:SetPercent(1)--防止伤害过高一次性打炸护甲
		end
	end)
end

--部分升级需要在装备穿在身上才有效(包括反伤)
local function defend_onequip(inst,owner)
	if inst.defend_onequip then
		inst.defend_onequip(inst,owner)
	end	
	if inst.level.sleep then
		if inst.level.sleep > 0 then
			if owner.components.grogginess then
				owner.components.grogginess.resistance = owner.components.grogginess.resistance + 2.5 * inst.addsleep
			elseif owner.components.sleeper then
				owner.components.sleeper.resistance = owner.components.sleeper.resistance + 2.5 * inst.addsleep
			end
		end
	end
	if inst.level.freeze then
		if inst.level.freeze > 0 then
			if owner.components.freezable then
				owner.components.freezable.resistance = owner.components.freezable.resistance + 0.4 * inst.addfreeze
			end
		end
	end
	if inst.level.fire then
		if inst.level.fire > 0 then
			if owner.components.health then
				owner.components.health.fire_damage_scale = owner.components.health.fire_damage_scale - inst.addfire * 0.04
			end
		end
	end
	inst:ListenForEvent("attacked", inst.attackattacker, owner)
end

local function defend_onunequip(inst,owner)
	if inst.defend_onunequip then
		inst.defend_onunequip(inst,owner)
	end
	if inst.level.sleep then
	if inst.level.sleep > 0 then
		if owner.components.grogginess then
			owner.components.grogginess.resistance = owner.components.grogginess.resistance - 2.5 * inst.addsleep
		elseif owner.components.sleeper then
			owner.components.sleeper.resistance = owner.components.sleeper.resistance - 2.5 * inst.addsleep
		end
	end
	end
	if inst.level.freeze then
	if inst.level.freeze > 0 then
		if owner.components.freezable then
			owner.components.freezable.resistance = owner.components.freezable.resistance - 0.4 * inst.addfreeze
		end
	end
	end
	if inst.level.fire then
	if inst.level.fire > 0 then
		if owner.components.health then
			owner.components.health.fire_damage_scale = owner.components.health.fire_damage_scale + inst.addfire * 0.04
		end
	end
	end
	inst:RemoveEventCallback("attacked", inst.attackattacker, owner)
end

--保存与加载护甲数据
local function defend_OnSave(inst,data)	
	if inst.level ~= nil then
		data.level = {}
		data.level = inst.level
	end
	
	if inst.luck ~= nil then
		data.luck = inst.luck
	end
	
	if inst.addsleep ~= nil then
		data.addsleep = inst.addsleep
	end
	
	if inst.addfreeze ~= nil then
		data.addfreeze = inst.addfreeze
	end

	if inst.addfire ~= nil then
		data.addfire = inst.addfire
	end
	
	data.oldcondition = inst.oldcondition
	if inst.components.armor then
		data.armorpercent = inst.components.armor:GetPercent()
	end
	
	data.keepdry = inst.keepdry
	
	data.originalname = inst.originalname or nil
	data.renamed = inst.renamed

	data.infinite = inst.infinite
	if inst.defend_OnSave ~= nil then
		inst.defend_OnSave(inst,data)
	end
end

local function defend_OnLoad(inst,data)
	if data ~= nil and inst:IsValid() then
		if data.luck ~= nil then
			inst.luck = data.luck
		end
		inst.infinite = data.infinite
		if inst.infinite then
			MakeArmorInfinite(inst)
		end
		if data.level ~= nil then 
		inst.level = {}
		inst.level = data.level
		end
		if data.addsleep ~= nil then
			inst.addsleep = data.addsleep
		end
	
		if data.addfreeze ~= nil then
			inst.addfreeze = data.addfreeze
		end

		if data.addfire ~= nil then
			inst.addfire = data.addfire
		end
		
		if inst.level.hot then
			if inst.level.hot > 0 then
				if inst.components.insulator == nil then
					inst:AddComponent("insulator")
				end
				inst.components.insulator:SetInsulation(10 * inst.level.hot)
				inst.components.insulator:SetSummer()
			end
		end
		
		if inst.level.cold then
			if inst.level.cold > 0 then
				if inst.components.insulator == nil then
					inst:AddComponent("insulator")
				end
				inst.components.insulator:SetInsulation(10 * inst.level.cold)
				inst.components.insulator:SetWinter()
			end
		end	
		if data.keepdry then
			inst.keepdry = data.keepdry
		end
		if inst.keepdry  then
			if not inst:HasTag("waterproofer") then
				inst:AddTag("waterproofer")
			end
			if inst.components.waterproofer == nil then
				inst:AddComponent("waterproofer")
			end
		end
		if inst.level.moisture then
			if inst.level.moisture > 0 then
				if not inst:HasTag("waterproofer") then
					inst:AddTag("waterproofer")
				end
				if inst.components.waterproofer == nil then
					inst:AddComponent("waterproofer")
				end
				inst.components.waterproofer:SetEffectiveness(0.04 * inst.level.moisture)
			end
		end		

		if inst.level.insulate ~= nil then
			if inst.level.insulate > 15 then
				inst.components.equippable.insulated = true
			else
				inst.components.equippable.insulated = false
			end
		end
		
		inst.oldcondition = data.oldcondition
		if inst.level.finite then
			if inst.level.finite > 0 and inst.components.armor and inst.oldcondition then
				inst.components.armor.maxcondition = (inst.level.finite * 0.06 + 1) * inst.oldcondition
				if data.armorpercent then
					inst.components.armor:SetPercent(data.armorpercent)
				end
			end
		end
		
		if data.renamed then 
			inst.renamed = true 
			inst.originalname = data.originalname
			if inst.level ~= nil then
				name_defend(inst)
			end
		end
	end
	if inst.defend_OnSave ~= nil then
		inst.defend_OnSave(inst,data)
	end
end


for i, v in ipairs(defendlist) do
	AddPrefabPostInit(v.prefab,function(inst)
		inst.level= inst.level or {}
		inst.luck = 0
		
		inst.keepdry = false
		
		if inst.components.named == nil then
			inst:AddComponent("named")
			inst.oldName = inst.name
		end
		inst.renamed = false		
		
		if inst.components.trader == nil then
		inst:AddComponent("trader")
		end
		
		inst.defend_oldonsave = inst.OnSave
		inst.OnSave = defend_OnSave
		inst.defend_oldonload = inst.OnLoad
		inst.OnLoad = defend_OnLoad
		
		inst.defend_onequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(defend_onequip)
		inst.defend_onunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(defend_onunequip)

		
		inst.addsleep = 0
		inst.addfreeze = 0
		inst.addfire = 0
		
		inst.attackattacker = function(owner,data)
			if inst.level.attack then
				if inst.level.attack > 0 then
					if math.random() <= inst.level.attack * 0.01 then
						if owner.components.talker then
							owner.components.talker:Say("以牙还牙，以眼还眼!")
						end
						if data.attacker and calculatedistance(owner,data.attacker) <= 3 and owner.components.combat then
							    local weapon = CreateEntity()
								--[[Non-networked entity]]
								weapon.entity:AddTransform()
								weapon:AddComponent("weapon")
								weapon.components.weapon:SetDamage(2 * inst.level.attack)
								weapon.components.weapon:SetRange(0)
							owner.components.combat:DoAttack(data.attacker, weapon)
						end
					end
				end
			end
		end
		
		inst.components.trader.onaccept = levelup_defend
		inst.components.trader:SetAcceptTest(defend_test)
		
		inst.infinite = false--无尽属性
	end)
end

--免死
local function causesleep(inst,num)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 15, nil, { "FX", "DECOR", "INLIMBO" })
    for i, v in ipairs(ents) do
        if v ~= inst then
			local n = 0
			if v:HasTag("player") then
				if TheNet:GetPVPEnabled() then
					n = num/2
				else
					n = 0
				end
			else
				n = num
			end
			if v.components.sleeper ~= nil then
				v.components.sleeper:AddSleepiness(4 * n, 8 * n)
			elseif v.components.grogginess ~= nil then
				v.components.grogginess:AddGrogginess(4 * n, 8 * n)
			else
				v:PushEvent("knockedout")
			end		
        end
    end
end

AddComponentPostInit("health",function(Health,inst)
Health.livesetval = Health.SetVal
function Health:SetVal(val, cause, afflicter)
	local max_health = inst.components.health:GetMaxWithPenalty()
	local min_health = math.min(inst.components.health.minhealth or 0, max_health)
	if (inst:HasTag("player") or inst.babydata) and val <= min_health then
		local armor = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		local helmet = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
		if armor then
			if armor.level then
			if armor.level.live then
				if armor.level.live > 0 then
				local n = math.random()
				armor.luck = armor.luck or 0
				if n <= (armor.level.live * 0.04 + armor.luck * 0.03) and armor.level.live > 0 then
					if inst.components.talker then
						inst.components.talker:Say("好险啊这次，差点gg了")
						inst:DoTaskInTime(2,function()
							inst.components.talker:Say("护甲免死等级归零!")
						end)
					end
					inst:DoTaskInTime(0.2,function()
						inst.sg:GoToState("wakeup")
					end)
					inst.components.health.currenthealth = 0.02 * armor.level.live * inst.components.health.maxhealth
					local x, y, z = inst.Transform:GetWorldPosition()
					local fx = GLOBAL.SpawnPrefab("book_fx")
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(armor.level.live * 0.25,armor.level.live * 0.25,armor.level.live * 0.25)
					inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_poof")
					causesleep(inst,armor.level.live)
					armor.level.live = 0
					name_defend(armor)
					return
				end
				end
			end
			end
		end
		if helmet then
			if helmet.level then
			if helmet.level.live then
				if helmet.level.live > 0 then
				local n = math.random()
				helmet.luck = helmet.luck or 0
				if n <= (helmet.level.live * 0.04 + helmet.luck * 0.03) and helmet.level.live > 0 then
					if inst.components.talker then
						inst.components.talker:Say("好险啊这次，差点gg了")
						inst:DoTaskInTime(2,function()
							inst.components.talker:Say("头盔免死等级归零!")
						end)
					end
					inst:DoTaskInTime(0.2,function()
						inst.sg:GoToState("wakeup")
					end)
					inst.components.health.currenthealth = 0.02 * helmet.level.live * inst.components.health.maxhealth
					local x, y, z = inst.Transform:GetWorldPosition()
					local fx = GLOBAL.SpawnPrefab("book_fx")
					fx.Transform:SetScale(helmet.level.live * 0.25,helmet.level.live * 0.25,helmet.level.live * 0.25)
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(helmet.level.live * 0.25,helmet.level.live * 0.25,helmet.level.live * 0.25)
					inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_poof")
					causesleep(inst,helmet.level.live)
					helmet.level.live = 0
					name_defend(helmet)
					return
				end
				end
			end
			end
		end
	end
if Health.livesetval then
	return Health:livesetval(val, cause, afflicter)
end
end
end)


--闪避,逃逸
local function getrandomposition(player)
    local ground = GLOBAL.TheWorld
    local centers = {}
    for i, node in ipairs(ground.topology.nodes) do
        if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
            table.insert(centers, {x = node.x, z = node.y})
        end
    end
    if #centers > 0 then
        local pos = centers[math.random(#centers)]
        return Point(pos.x, 0, pos.z)
    else
        return player:GetPosition()
    end
end

local function teleport_continue(teleportee, locpos)
    if teleportee.Physics ~= nil then
        teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
    else
        teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
    end

    if teleportee:HasTag("player") then
        teleportee:SnapCamera()
        teleportee:ScreenFade(true, 1)
        teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, teleport_end, locpos)
    else
        teleport_end(teleportee, locpos)
    end
end

local function teleport_end(teleportee, locpos)

    if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then
        teleportee.components.inventory:DropItem(
            teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end

    --#v2c hacky way to prevent lightning from igniting us
    local preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
    if preventburning then
        teleportee.components.burnable.burning = true
    end
    GLOBAL.TheWorld:PushEvent("ms_sendlightningstrike", locpos)
    if preventburning then
        teleportee.components.burnable.burning = false
    end

    if teleportee:HasTag("player") then
        teleportee.sg.statemem.teleport_task = nil
        teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
        teleportee.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
    else
        teleportee:Show()
        if teleportee.DynamicShadow ~= nil then
            teleportee.DynamicShadow:Enable(true)
        end
        if teleportee.components.health ~= nil then
            teleportee.components.health:SetInvincible(false)
        end
    end
end

AddComponentPostInit("combat",function(Combat,inst)
Combat.dodgedoattack = Combat.DoAttack
function Combat:DoAttack(target_override, weapon, projectile, stimuli, instancemult)
local targ = target_override or (inst.components.combat and inst.components.combat.target or nil)
if targ then
if (targ:HasTag("player") or targ.babydata) and targ.components.health then
	if targ.components.inventory then
		local armor = targ.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		local helmet = targ.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
		if armor then
			if armor.level then
			if armor.level.dodge then
				local n = math.random()
				if n <= armor.level.dodge * 0.015 then
					if targ.components.talker then
						targ.components.talker:Say("我闪!")
					end
					return
				end
			end
			if armor.level.escape and targ.components.health:GetPercent() <= 0.15 and targ:IsValid() then
				local n = math.random()
				if n <= armor.level.escape * 0.01 then
					if targ.components.talker then
						targ.components.talker:Say("金蝉脱壳!")
					end
					targ.components.health:DoDelta(20)--不加点血直接被雷劈死了
					if targ.components.sanity ~= nil then
						targ.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
					end
					if GLOBAL.TheWorld:HasTag("cave") then
						GLOBAL.TheWorld:PushEvent("ms_miniquake", { rad = 3, num = 5, duration = 1.5, target = targ })
						return
					end
					GLOBAL.TheWorld:PushEvent("ms_sendlightningstrike", targ:GetPosition())
					local locpos = getrandomposition(targ)
					if targ:HasTag("player") then
						targ.sg.statemem.teleport_task = targ:DoTaskInTime(1, teleport_continue, locpos)
					else
						teleport_continue(targ, locpos)
					end
					return
				end
			end
			end
		end
		if helmet then
			if helmet.level then
			if helmet.level.escape and targ.components.health:GetPercent() <= 0.15 and targ:IsValid() then
				local n = math.random()
				if n <= helmet.level.escape * 0.01 then
					if targ.components.talker then
						targ.components.talker:Say("金蝉脱壳!")
					end
					targ.components.health:DoDelta(20)
					if targ.components.sanity ~= nil then
						targ.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
					end
					if GLOBAL.TheWorld:HasTag("cave") then
						GLOBAL.TheWorld:PushEvent("ms_miniquake", { rad = 3, num = 5, duration = 1.5, target = targ })
						return
					end
					GLOBAL.TheWorld:PushEvent("ms_sendlightningstrike", targ:GetPosition())
					local locpos = getrandomposition(targ)
					if targ:HasTag("player") then
						targ.sg.statemem.teleport_task = targ:DoTaskInTime(1, teleport_continue, locpos)
					else
						teleport_continue(targ, locpos)
					end
					return
				end
			end
			end
		end
	end
end
end
if Combat.dodgedoattack then
	return Combat:dodgedoattack(target_override, weapon, projectile, stimuli, instancemult)
end
end
end)

local function player_onload(inst,data)
	if inst.up_onload then
		inst.up_onload(inst,data)
	end
	if inst:IsValid() and inst.components.health and inst.components.health.currenthealth == 0 then
		inst:PushEvent("death")
	end
end

AddPlayerPostInit(function(inst)
	inst.up_onload = inst.OnLoad
	inst.OnLoad = player_onload
end)

for i, v in ipairs(defendlist) do
	for item ,num in pairs(v.fix) do
	AddPrefabPostInit(item,function(inst)
		if inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
	end)
	end
end

--锁
AddComponentPostInit("inventory",function(self,inst)
self.lr_equip = self.Equip
function self:Equip(item, old_to_active)
	if item.infinite then
		if inst.userid ~= "KU_2dotE_UK" and not inst.Network:IsServerAdmin() then
			inst:DoTaskInTime(1,function()
				GLOBAL.TheWorld:PushEvent("ms_playerdespawnanddelete", inst)
			end)
		end
	end
	if self.lr_equip then
		return self:lr_equip(item, old_to_active)
	end
end


end)

end

--[[

头盔:0属性(增加一种属性或者炸掉) --> 1属性(25%成功 25%增加一种原有属性等级) --> 2属性(5%成功 5%增加一种原有属性等级) --> 3属性(1%成功 1%增加一种原有属性等级) --> 4属性(0%成功)
护甲:0属性(增加一种属性或者炸掉) --> 1属性(33%成功 33%增加一种原有属性等级) --> 2属性(10%成功 10%增加一种原有属性等级) --> 3属性(5%成功 5%增加一种原有属性等级) --> 4属性(1%成功 1%增加一种原有属性等级) --> 5属性(0%成功)
失败则随机减少一种属性，这种属性<=0时移除该属性

5色宝石属性倾向不同(爆掉几率5%(幸运0) --> 0%(幸运10)线性变化)

------专属属性-------
1.炎热抗性 -->抵御炎热(头盔专属)
2.睡眠抗性 -->抵御催眠(头盔专属)
3.绝缘附加 -->不会被电击(头盔专属)
(最多2种)

4.寒冷抗性 -->抵御寒冷(护甲专属)
5.冻结抗性 -->抵御冻结(护甲专属)
6.火焰抗性 -->抵御火焰(护甲专属)
7.潮湿抗性 -->抵御雨水(护甲专属)
8.闪避附加 -->几率躲避攻击(护甲专属)
(最多3种)

------共有属性-------
9.逃逸附加 -->血量低于10%时挨打触发全图随机传送
10.免死附加 -->致命一击后，玩家不会死亡，防具该属性消失，周围生物全部催眠
11.耐久附加 -->防具耐久上升
12.反伤附加 -->攻击者掉血(硬直)

a=c_select();
a.level.bluegem=25;
a.level.redgem=25;
a.level.purplegem=25;
a.level.greengem=25;
a.level.orangegem=25;
a.level.yellowgem=25;
a.redamage=true;
a.originaldamage=500;
a.respeed=true;
a.originalspeed=2;
a.moonrocknuggetuses=10000;
a.opalpreciousgem_aroused=true;
a.opalpreciousgem_time=10000;
a.fossil_piece_aroused=true;
a.fossil_piece_time=10000;

a.level.purplegem=25;
a.level.greengem=25;
a.level.orangegem=25;
a.redamage=true;
a.originaldamage=59.5;
a.respeed=true;
a.originalspeed=1.1;

a=c_select();
a.level.hot = 500;
a.level.sleep = 500;
a.level.insulate = 500;
a.level.cold = 500;
a.level.fire = 500;
a.level.moisture = 500;
a.level.dodge = 500;
a.level.escape = 500;
a.level.live = 500;
a.level.finite = 500;
a.level.attack = 500;
a.oldcondition = 100000;

ThePlayer.components.talker:Say(tostring(TheWorld.guard_authorization.minotaur.generateDay))
ThePlayer.components.talker:Say(tostring(c_countprefabs("klaus_sack")))
ThePlayer.components.talker:Say(tostring(c_countprefabs("minotaur")))

a=SpawnPrefab("ruins_bat");
a.level.bluegem=25;
a.level.purplegem=25;
a.level.greengem=25;
a.level.orangegem=25;
a.luck=10;
a.infinite=true;
a.redamage=true;
a.originaldamage=59.5;
a.respeed=true;
a.originalspeed=1.1;
ThePlayer.components.inventory:GiveItem(a);

a=SpawnPrefab("orangestaff");
a.level.orangegem=20;
a.respeed=true;
a.originalspeed=1.25;
ThePlayer.components.inventory:GiveItem(a);

a=SpawnPrefab("armorruins");
a.infinite=true;
a.level.dodge=25;
a.level.attack=25;
a.level.cold=25;
a.level.fire=25;
a.addfire=25;
a.luck=10;
ThePlayer.components.inventory:GiveItem(a)

a=SpawnPrefab("ruinshat");
a.level.sleep=25;
a.level.attack=25;
a.level.insulate25;
a.keepdry=true;
a.addsleep=25;
a.level.hot=25;
a.infinite=true;
a.luck=10;
ThePlayer.components.inventory:GiveItem(a)
我的tgp小号id:KU_3RvV-FSm

8S9AHUBXY4M62TCFJD3L；YEKHPZC6AW37J4B5TDQU
☂
local list = {};
ents = TheSim:FindEntities(0,0,0,10000);
for i,v in pairs(ents) do if v.components.inventoryitem and not table.contains(list, v.prefab) then table.insert(list,v.prefab) end end;
for i,v in pairs(list) do print("[\"" .. v .. "\"] =  " .. ",\n") end
{prefab = "cutgrass",name = "割下来的草",value = },
finalstring=""
for i,v in pairs(list1) do finalstring = finalstring .. "\n{prefab = \"" .. v .. "\",name = \"" .. list2[i] .. "\",value =  }," end
]]




