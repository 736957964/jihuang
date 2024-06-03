GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


	
if  IsServer then



local function rw_name(inst)
	
		-- local pos = Vector3(inst.Transform:GetWorldPosition())
		-- local ents = TheSim:FindEntities(pos.x,pos.y+3.9,pos.z, 1)
			-- for k,v in pairs(ents) do
				-- if v:HasTag("SHtietu") then
				   -- v:Remove()
				-- end
			-- end


		
		--pigelite1  --moon_fissure_fx
		local SHtietu = SpawnPrefab("pigelite1")
		
		SHtietu.AnimState:PlayAnimation("noanim")
		SHtietu.Physics:SetActive(false)
		SHtietu.DynamicShadow:Enable(false)

		SHtietu:SetBrain(nil)
		--SHtietu.sg:Stop()
		SHtietu:AddTag("FX")
		
		SHtietu:RemoveTag("cavedweller")
		SHtietu:RemoveTag("character")
		SHtietu:RemoveTag("pig")
		SHtietu:RemoveTag("manrabbit")
		SHtietu:RemoveTag("scarytoprey")

		SHtietu:RemoveComponent("locomotor")
		SHtietu:RemoveComponent("bloomer")
		SHtietu:RemoveComponent("eater")
		SHtietu:RemoveComponent("combat")
		SHtietu:RemoveComponent("follower")
		SHtietu:RemoveComponent("health")
		SHtietu:RemoveComponent("inventory")
		SHtietu:RemoveComponent("lootdropper")
		SHtietu:RemoveComponent("knownlocations")
		SHtietu:RemoveComponent("trader")
		SHtietu:RemoveComponent("sanityaura")
		SHtietu:RemoveComponent("sleeper")
		SHtietu:RemoveComponent("lootdropper")
		SHtietu:RemoveComponent("burnable")
		SHtietu:RemoveComponent("freezable")

		SHtietu.components.talker.ontalk = nil

		SHtietu.labeltask = SHtietu:DoPeriodicTask( 4, function()
								SHtietu.components.talker:Say("↘[境界称号]↙\n[   ] \n \n \n \n \n \n \n \n \n\n", 5, false)
							end )

		SHtietu.UpdateLabel = function(SHtietu, string)
			SHtietu.components.talker:Say(string, 5, false)
			SHtietu.labeltask:Cancel()
			SHtietu.labeltask = nil
			SHtietu.labeltask = SHtietu:DoPeriodicTask( 4, function()
									SHtietu.components.talker:Say(string, 5, false)
								end )
		end
			SHtietu:DoTaskInTime( 4, function()
					SHtietu.components.talker:Say("↘[境界称号]↙\n[    ] \n \n \n \n \n \n \n \n \n\n", 5, false)
			end )
		

		--SHtietu.AnimState:PlayAnimation( action , true)	--动作
		--SHtietu.entity:SetParent(inst.entity)	
		--SHtietu.AnimState:SetMultColour(1,1,1,.5)		--颜色
		--SHtietu.Transform:SetScale( size, size, size)	--大小
		--SHtietu.Transform:SetPosition(0,4,0)			--位置
		--SHtietu.Transform:SetRotation(270)  --其实没用到
		SHtietu.persists = false
		SHtietu:AddTag("SHtietu")
		SHtietu:AddTag("haunted")         ----------添加作祟标签

	
end


if GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated() then

	AddPlayerPostInit(function(inst)

		rw_name(inst)	

	end)
	
end


end

