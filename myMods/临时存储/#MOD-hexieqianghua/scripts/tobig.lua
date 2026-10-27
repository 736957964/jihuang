eviltobignum = GetModConfigData("eviltobignum")
neutraltobignum = GetModConfigData("neutraltobignum")
bosstobignum = GetModConfigData("bosstobignum")
--function GameSetup(inst)
--inst:AddComponent("ResetOnEmpty")
--end
--AddPrefabPostInit("world", GameSetup)
--------------------------------------生物变大------------
local eviltobigtable = {
"spider","spider_spitter","spider_warrior","spider_hider","spider_dropper","killerbee","hound","bat","worm","firehound","icehound"
}

local neutraltobigtable = {
"beefalo","rabbit","tallbird","walrus","killerbee","pigman","bunnyman","catcoon","koalefant_summer","koalefant_winter",
"buzzard","penguin","perd","bishop","knight","rook","slurtle","merm","slurper","rocky","leif","leif_sparse"
}

local bosstobigtable = {
"deerclops","bearger","moose","minotaur","spiderqueen","warg","dragonfly"
}



local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
    if data.attacker ~= nil and
        not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
        (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
        data.attacker.components.burnable ~= nil and
        not data.redirected and
        not data.attacker:HasTag("thorny") then
        data.attacker.components.burnable:Ignite()
    end
end





local function eviltobig(inst)	--体积，血量，攻击距离，攻击力
	local currentscale = inst.Transform:GetScale()
	local canbebig = (currentscale < 1.24)
	
	if canbebig == true then
		if eviltobignum == 1 then
			--print("num = 1！！！")
			local therandom = math.random()
			if therandom < .2 then		--1.25倍
				
				inst.Transform:SetScale(currentscale*1.25,currentscale*1.25,currentscale*1.25)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.25
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 1.5	--1.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.125
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.125
				end
				inst:ListenForEvent("death", function ()
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))   --1.5倍掉落
					end
				end)
			elseif therandom < .5 then   -- 1.5倍
				
				
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.5
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2			--2倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.25
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.25
				end
				
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		--2倍掉落
				end)
			elseif therandom < .6 then	--1.75倍
				
				inst.Transform:SetScale(currentscale*1.75,currentscale*1.75,currentscale*1.75)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.75
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.375
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.375
				end
				
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			elseif therandom < .7 then	--2倍
				
				
				
				inst.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 3			--3倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.5
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.5
				end
				
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--3倍掉落
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
				end)
				
			end
		elseif eviltobignum == 2 then
			--print("num = 2！！！")
			local therandom = math.random()
			if therandom < .2 then		--1.25倍
				inst.Transform:SetScale(currentscale*1.25,currentscale*1.25,currentscale*1.25)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2	--2倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.125
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.125
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))   --2倍掉落
				end)
			elseif therandom < .6 then   -- 1.5倍
				
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2.5
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.25		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.25
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.25
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end 					--2.5倍掉落
				end)
				
				
				
			elseif therandom < .7 then	--大力怪
			
				inst.AnimState:SetMultColour(216/255,0/255,255/255,1)
				inst.Transform:SetScale(currentscale*1.75,currentscale*1.75,currentscale*1.75)
				
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2.5
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.75		--2.75倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.375
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.375
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)				
				
			elseif therandom < .8 then	--火焰怪
			inst:ListenForEvent("attacked", OnBlocked)
				inst.AnimState:SetMultColour(255/255,0/255,0/255,1)
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.375
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.375
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			elseif therandom < .9 then	--冰霜怪
			inst.freezefn = function (attacked, data)
					if data and data.attacker and data.attacker.components.freezable then
						data.attacker.components.freezable:AddColdness(0.67)
						data.attacker.components.freezable:SpawnShatterFX()
						
					end
				end
				
				inst:ListenForEvent("attacked", inst.freezefn)
				inst.AnimState:SetMultColour(0/255,0/255,255/255,1)
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.375
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.375
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--3倍掉落
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
				end)
			end
			
		end
	end
end


local function neutraltobig(inst,target)	--体积，血量，攻击距离，攻击力
	local currentscale = inst.Transform:GetScale()
	local canbebig = (currentscale < 1.24)
	if canbebig == true then
		if neutraltobignum == 1 then
			local therandom = math.random()
			if therandom < .3 then		--1.25倍
				inst.Transform:SetScale(currentscale*1.25,currentscale*1.25,currentscale*1.25)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.25
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 1.5	--1.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.125
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.125
				end
				inst:ListenForEvent("death", function ()
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))   --1.5倍掉落
					end
				end)
			elseif therandom < .5 then   -- 1.5倍
				
				
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.5
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2			--2倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.25
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.25
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		--2倍掉落
				end)
			elseif therandom < .7 then   -- 1.75倍
				inst.AnimState:SetMultColour(255/255,0/255,0/255,1)
				inst.Transform:SetScale(currentscale*1.75,currentscale*1.75,currentscale*1.75)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 1.75
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.25		--2.25倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.30
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.30
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			end
		elseif neutraltobignum == 2 then
			local therandom = math.random()
			if therandom < 0.6 then		--1.25倍
				
				inst.Transform:SetScale(currentscale*1.25,currentscale*1.25,currentscale*1.25)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2	--1.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.125
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.125
				end
				inst:ListenForEvent("death", function ()
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))   --1.5倍掉落
					end
				end)
			elseif therandom < .7 then	--大力怪
			
				inst.AnimState:SetMultColour(216/255,0/255,255/255,1)
				inst.Transform:SetScale(currentscale*1.75,currentscale*1.75,currentscale*1.75)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2.5
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.75		--2.75倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.30
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.30
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition())) 	--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			elseif therandom < 0.8 then   -- 火焰怪
				inst:ListenForEvent("attacked", OnBlocked)
				inst.AnimState:SetMultColour(255/255,0/255,0/255,1)
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.30
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.30
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			elseif therandom < 0.9 then   -- 冰霜怪
				inst.freezefn = function (attacked, data)
					if data and data.attacker and data.attacker.components.freezable then
						data.attacker.components.freezable:AddColdness(0.67)
						data.attacker.components.freezable:SpawnShatterFX()
						
					end
				end
				
				inst:ListenForEvent("attacked", inst.freezefn)
				inst.AnimState:SetMultColour(0/255,0/255,255/255,1)
				inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
				if inst.components.health then
					inst.components.health.maxhealth = inst.components.health.maxhealth * 2
					inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
				end
				if inst.components.combat then
					inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2.5倍攻击
					inst.components.combat.attackrange=inst.components.combat.attackrange * 1.30
					inst.components.combat.hitrange=inst.components.combat.hitrange * 1.30
				end
				inst:ListenForEvent("death", function ()
					inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		--2.5倍掉落
					if math.random() < .5 then
						inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
					end
				end)
			end
		end
	end
end

local function bosstobig(inst)
	local currentscale = inst.Transform:GetScale()
	if bosstobignum == 1 then
		inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
		if inst.components.health then
			inst.components.health.maxhealth = inst.components.health.maxhealth * 1.5
			inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
		end
		if inst.components.combat then
			inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 1.5	--1.5倍攻击
			inst.components.combat.attackrange=inst.components.combat.attackrange * 1.125
			inst.components.combat.hitrange=inst.components.combat.hitrange * 1.125
		end
	elseif bosstobignum == 2 then
		inst.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
		if inst.components.health then
			inst.components.health.maxhealth = inst.components.health.maxhealth * 2
			inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
		end
		if inst.components.combat then
			inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * 2.5		--2倍攻击
			inst.components.combat.attackrange=inst.components.combat.attackrange * 1.25
			inst.components.combat.hitrange=inst.components.combat.hitrange * 1.25
		end
	end
end

for k,v in pairs(eviltobigtable) do
	AddPrefabPostInit(v, eviltobig)
end

for k,v in pairs(neutraltobigtable) do
	AddPrefabPostInit(v, neutraltobig)
end

for k,v in pairs(bosstobigtable) do
	AddPrefabPostInit(v, bosstobig)
end