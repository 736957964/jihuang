
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
				
AddPrefabPostInit("pigking",function(inst)
	if inst  then
	    
		inst:DoTaskInTime(0,function()
		---local x,y,z = inst.Transform:GetWorldPosition()
		local pt = Vector3(inst.Transform:GetWorldPosition())		
		for k = 1, 50 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 8.5, 50, function(offset)
            local x,y,z = (pt + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
            local border = SpawnPrefab("lightbulb")
            border.Transform:SetPosition((pt + result_offset):Get())
			----border.Transform:SetPosition(x,0,z)
            border.AnimState:SetBank("bulb")
            border.AnimState:SetBuild("bulb")
            border.AnimState:PlayAnimation("idle")
            border.Transform:SetScale(1.2, 1.2, 1.2)
            border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
            border.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
            border.AnimState:SetLayer( LAYER_BACKGROUND )
            border.AnimState:SetSortOrder( 1 )
            border:RemoveComponent("inventoryitem")
            border:RemoveComponent("stackable")
			border:RemoveComponent("perishable")
			border:RemoveComponent("edible")  ----可以吃
            border:RemoveTag("cattoy")
			border.persists = false	
            border:DoPeriodicTask(2, function()
               border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               border:DoTaskInTime(1, function() border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end)
            end)
            border:AddTag("NOCLICK")
            border:AddTag("border")
			local light = border.entity:AddLight()
			light:SetFalloff(0.5)
			light:SetIntensity(.8)
			light:SetRadius(5)
			light:SetColour(180/255, 195/255, 50/255)
			light:Enable(true)
		end
				
				
				
			end
		end)
		
	end
end)



