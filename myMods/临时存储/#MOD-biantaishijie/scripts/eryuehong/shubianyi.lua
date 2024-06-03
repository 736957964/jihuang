
local _G = GLOBAL
IsSpecialEventActive = GLOBAL.IsSpecialEventActive
---------------------------全事件开启~~~~~~~~~~~~~~~
AddPrefabPostInit( "world", function(TheWorld)
	TheWorld:DoTaskInTime( 0, function(TheWorld) 
		for k, v in pairs(GLOBAL.SPECIAL_EVENTS) do 
			if v ~= GLOBAL.SPECIAL_EVENTS.NONE  then 
				local tech = GLOBAL.TECH[k] 
					if tech ~= nil then 
						GLOBAL.TECH[k].SCIENCE = 0 
					end 
			end 
		end
		
		local  function  IsSpecialEventActive(event) 
		
		return true
		
        end 
		
   end)
   
end)
-------------------------树的变异

local function change(inst)
	if inst and GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("zg_creature_variation")
		inst.components.zg_creature_variation:SetVariationTime(60)
		inst.components.zg_creature_variation:StartVariation()
		inst.components.zg_creature_variation.onvariationreplacement = { leif = 0.3, 
	        	bearger= 0.3, warg= 0.3, worm= 0.3, deerclops= 0.3,
		terrorbeak= 0.3,rook= 0.3, bishop= 0.3, slurper= 0.3,catcoon= 0.3,merm= 0.3,}
		inst.components.zg_creature_variation.chance = 0.01
	end
end

AddPrefabPostInit("evergreen", change)
AddPrefabPostInit("evergreen_normal", change)
AddPrefabPostInit("evergreen_short", change)
AddPrefabPostInit("deciduoustree_normal", change)
AddPrefabPostInit("deciduoustree_short", change)
AddPrefabPostInit("deciduoustree", change)















