local atable = {
	"wall_hay", "wall_wood", "wall_stone", "wall_ruins", "wall_moonrock"
	}
	
local function a(inst)
	if inst.components.health then
	inst.components.health.currenthealth = inst.components.health.maxhealth
	inst.components.health:DoDelta(0)
		inst.components.health:SetInvincible( true )
	end
end

for k,v in pairs(atable) do
	AddPrefabPostInit(v, a)
end




local comb_rep = GLOBAL.require "components/combat_replica"
local old_IsAlly = comb_rep.IsAlly
function comb_rep:IsAlly(guy,...)
	if guy:HasTag("wall") then
		return true
	end
	return old_IsAlly(self,guy,...)
end



