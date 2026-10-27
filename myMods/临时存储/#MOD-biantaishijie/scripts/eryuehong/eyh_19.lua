local SpawnPrefab = GLOBAL.SpawnPrefab
local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local function rwxs(eater)
	eater:SnapCamera()
	eater:ScreenFade(true, 2)
	eater:Show()
end

local function GetStatus(eater,inst)
	local function tmi_goto(prefab) 
		if inst.zbw == 0 then
			inst.zbw = 1
			if prefab ~= nil then
				if eater.Physics ~= nil then
					eater.Physics:Teleport(prefab.Transform:GetWorldPosition())
				else
					eater.Transform:SetPosition(prefab.Transform:GetWorldPosition()) 
				end	
			end
		else
			inst.zbw = 0
			if inst.zbx ~= nil and inst.zby ~= nil and inst.zbz ~= nil then
				if inst.zbx + inst.zby +inst.zbz ~= 0 then
					if eater.Physics ~= nil then
						eater.Physics:Teleport(inst.zbx,inst.zby,inst.zbz)
					else
						eater.Transform:SetPosition(inst.zbx,inst.zby,inst.zbz) 
				    end				
				else
					if prefab ~= nil then
						if eater.Physics ~= nil then
							eater.Physics:Teleport(prefab.Transform:GetWorldPosition())
						else
							eater.Transform:SetPosition(prefab.Transform:GetWorldPosition()) 
						end	
					end	
				end	
			end	
		end	
		eater:DoTaskInTime(0.5, rwxs)	
	end 
	local target = GLOBAL.FindEntity(eater, 15000, nil, { "spawnportal" }, nil)
	if target == nil then 
		target = GLOBAL.FindEntity(eater, 15000, nil, {" "}, nil)
	end 
	tmi_goto(target) 
end




local function GetStatuszb(inst)

    local eater = inst.components.inventoryitem:GetGrandOwner()
    while eater ~= nil and eater.components.container ~= nil do
        eater = eater.components.container.opener
    end

	
	----inst.components.fueled:SetPercent(100)
	
	
	
	if eater ~= nil  then 
		eater:ScreenFade(false)
		eater:Hide()
		eater:DoTaskInTime(0.5, GetStatus,inst)
		
	end
end



local function dwzb(inst, item, giver)
inst.zbx,inst.zby,inst.zbz = inst.Transform:GetWorldPosition()
giver.components.talker:Say("飞行石定位成功\n可右键使用飞回此处")
return false
end


local function OnSave(inst,data)
	if inst.zbx ~= nil and inst.zby ~= nil and inst.zbz ~= nil then
		data.zbx = inst.zbx
		data.zby = inst.zby
		data.zbz = inst.zbz
	end 
end

local function OnLoad(inst,data)
	if data.zbx ~= nil and data.zby ~= nil and data.zbz ~= nil then
		inst.zbx = data.zbx
		inst.zby = data.zby
		inst.zbz = data.zbz
	end 
end

local function heatrockpostinit(inst)
	inst.components.inspectable.getstatus = GetStatuszb
	inst.zbx = 0
	inst.zby = 0
	inst.zbz = 0
	inst.zbw = 0	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(dwzb)
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad	
end
local function bbpostinit(inst)
	inst.components.inventoryitem.cangoincontainer = true
end

AddPrefabPostInit("heatrock", heatrockpostinit)
AddPrefabPostInit("multiplayer_portal", 	function(inst)	 inst:AddTag("spawnportal") 
end)


local bbtable = {
	"backpack", --背包
	"icepack", 
	"krampus_sack",
	"piggyback",
}

for k, v in pairs(bbtable) do
	AddPrefabPostInit(v, bbpostinit)
end



