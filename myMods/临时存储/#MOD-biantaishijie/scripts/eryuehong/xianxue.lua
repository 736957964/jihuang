
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
IsServer = TheNet:GetIsServer()


-------------------------------------怪物随天数增强血量 

----怪物的列表
local healthtable = 
{
	"bearger",     "minotaur",
	"deerclops",   "dragonfly",
	"warg",        "moose",
	"spiderqueen", "leif", 
	"leif_sparse",
}


local function HealthChange(inst)
	if inst and GLOBAL.TheWorld.ismastersim then     
	    local day = GLOBAL.TheWorld.state.cycles
		local a   = inst.components.health.currenthealth
	    if GLOBAL.TheWorld.state.cycles  <   30 then
			inst.components.health:SetMaxHealth(a+5000)          
			inst.components.health:SetAbsorptionAmount(.2)     
        elseif GLOBAL.TheWorld.state.cycles < 100 then 
		    inst.components.health:SetMaxHealth(a+15000)
			inst.components.health:SetAbsorptionAmount(.4)
		else
		    inst.components.health:SetMaxHealth(a+day*500)
            inst.components.health:SetAbsorptionAmount(.4 + day*0.0005 )			
		end				
    end	
end
	
for k, v in pairs(healthtable) do
	AddPrefabPostInit(v, HealthChange)
end


-------------------------------------------显示血量-----用于测试的。。。。
--[[local function health_OnSave(inst,data)
	if inst.health_onsave then
		inst.health_onsave(inst,data)
	end
	if inst.health_oldname ~= nil then
		data.health_oldname = inst.health_oldname
	end
end

local function health_OnLoad(inst,data)
	if inst.health_onload then
		inst.health_onload(inst,data)
	end
	if data then
		if data.health_oldname ~= nil then
			inst.health_oldname = data.health_oldname
		end
	end
end

AddPrefabPostInitAny(function(inst)
    if inst.components.health and not inst:HasTag("player") then
	if inst.components.named == nil then
		inst:AddComponent("named")
	end
	inst.health_oldname = inst.name or inst:GetDisplayName()
	local healthstring = inst.health_oldname .. "  " .. " ♥ " .. tostring(math.ceil(inst.components.health.currenthealth)) .. "/" .. tostring(inst.components.health.maxhealth) .. " ♥"
	inst.components.named:SetName(healthstring)
	
	
	inst:ListenForEvent("healthdelta" ,function(inst,data)
	local healthstring = inst.health_oldname .. "  " .. " ♥ " .. tostring(math.ceil(inst.components.health.currenthealth)) .. "/" .. tostring(inst.components.health.maxhealth) .. " ♥"
	inst.components.named:SetName(healthstring)
	end)
	inst.health_onsave = inst.OnSave
	inst.OnSave = health_OnSave
	inst.health_onload = inst.OnLoad
	inst.OnLoad = health_OnLoad
end
end)]]



