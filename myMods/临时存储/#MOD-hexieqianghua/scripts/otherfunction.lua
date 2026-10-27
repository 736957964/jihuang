-------------------------------------其他更改-----------------------------------
GetRandomItem = GLOBAL.GetRandomItem
--[[
直接的文本修改
1.mainfunctions.lua SpawnPrefab函数 if name == nil then return end


]]
--蔓草治病
local plantlist = {
"grass",
"sapling",
"berrybush",
"berrybush2",
"berrybush_juicy",
}


local function heal(inst,item,giver)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,3)
	GLOBAL.SpawnPrefab("book_fx").Transform:SetPosition(x,y,z)
	for i,v in pairs(ents) do
		if v.components.diseaseable then
			v.AnimState:SetMultColour(0,0.8,0,0.8)
			if v.prefab == "grass" then
				v.AnimState:SetBuild("grass1")
				v.components.pickable:ChangeProduct("cutgrass")
			end
			if v.prefab == "sapling" then
				v.AnimState:SetBuild("sapling")
				v.components.pickable:ChangeProduct("twigs")
			end
			if v.prefab == "berrybush" then
				v.AnimState:SetBuild("berrybush")
				v.components.pickable:ChangeProduct("berries")
			end
			if v.prefab == "berrybush2" then
				v.AnimState:SetBuild("berrybush2")
				v.components.pickable:ChangeProduct("berries")
			end
			if v.prefab == "berrybush_juicy" then
				v.AnimState:SetBuild("berrybush_juicy")
				v.components.pickable:ChangeProduct("berries_juicy")
			end
			v:DoTaskInTime(1,function()
				v.AnimState:SetMultColour(1,1,1,1)
			end)
			v:RemoveComponent("diseaseable")
		end
	end
end

for i,v in ipairs(plantlist) do
	AddPrefabPostInit(v,function(inst)
	if inst.components.trader == nil then
		inst:AddComponent("trader")
	end
	inst.components.trader.onaccept = heal
	inst.components.trader:SetAcceptTest(function(inst,item,giver)
		if item.prefab ~= "mandrake" then
			if giver.components.talker then
				giver.components.talker:Say("用曼德拉草才可以给植物治病!")
			end
			return false
		end
		if inst.components.diseaseable == nil then
			if giver.components.talker then
				giver.components.talker:Say("它不需要治愈!")
			end
			return false
		end
		return true
	end)
end)
end

AddPrefabPostInit("mandrake",function(inst)
if inst.components.tradable == nil then
	inst:AddComponent("tradable")
end
end)

AddPlayerPostInit(function(inst) 
    if inst.prefab ~= nil then 
    end 
    inst:AddTag("compassbearer")
	inst:AddTag("maprevealer")
    inst:AddComponent("maprevealer")	 
	if inst.components.maprevealable ~= nil then
       inst.components.maprevealable:AddRevealSource(inst, "compassbearer")
    end
end)   



--限制制作木牌
local viplist = {
"KU_au1ThihJ",--TGP我的大号ID
"KU_d2kn7aNq",--日光倾城
"KU_OfyhzhLS",--皮


}

local function identifyvip(inst)
for i,v in ipairs(viplist) do
	if v == inst.userid then
		return true
	end
end
return false
end

local function homesign_OnSave(inst,data)
	if inst.homesign_onsave then
		inst.homesign_onsave(inst,data)
	end
	if inst.cleantime ~= nil then
		data.cleantime = inst.cleantime
	end
end

local function homesign_OnLoad(inst,data)
	if inst.homesign_onload then
		inst.homesign_onload(inst,data)
	end
	if data then
		if data.cleantime ~= nil and data.cleantime ~= 0 then
			inst.cleantime = data.cleantime
			inst.AnimState:SetMultColour(1,0,0,0.9)
				inst.cleantask = inst:DoPeriodicTask(1,function()
				inst.cleantime = inst.cleantime - 1
				if inst.cleantime <= 0 then
					inst:Remove()
				end				
			end)
		end
	end
end

AddPrefabPostInit("homesign" ,function(inst)
	inst:ListenForEvent("onbuilt", function(inst,data)
			if not data.builder.Network:IsServerAdmin() and not identifyvip(data.builder) then
			if data.builder.components.talker then
				data.builder.components.talker:Say("非特殊玩家木牌3600秒将自动清理!")
			end
			inst.AnimState:SetMultColour(1,0,0,0.9)
				inst.cleantime = 3600
					inst.cleantask = inst:DoPeriodicTask(1,function()
					inst.cleantime = inst.cleantime - 1
					if inst.cleantime <= 0 then
						inst:Remove()
					end				
				end)
			end
	end)
	inst.homesign_onsave = inst.OnSave
	inst.OnSave = homesign_OnSave
	inst.homesign_onload = inst.OnLoad
	inst.OnLoad = homesign_OnLoad
end)



