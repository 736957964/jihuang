local assets =
{
    Asset("ANIM", "anim/diviningrod.zip"),
    Asset("ANIM", "anim/swap_diviningrod.zip"),
    Asset("ANIM", "anim/diviningrod_fx.zip"),
}

local prefabs =
{
    "dr_hot_loop",
    "dr_warmer_loop",
    "dr_warm_loop_2",
    "dr_warm_loop_1",
}

local EFFECTS =
{
    hot = "dr_hot_loop",
    warmer = "dr_warmer_loop",
    warm = "dr_warm_loop_2",
    cold = "dr_warm_loop_1",
}

local function FindClosestPart(inst)

    if inst.tracking_parts == nil then
        inst.tracking_parts = {}
        for k,v in pairs(Ents) do
            if v:HasTag("teleportato") or v:HasTag("teleportato_part") or v.prefab == "adventure_portal" then
                table.insert(inst.tracking_parts, v)
            end
        end
    end

    if inst.tracking_parts then
        local closest = nil
        local closest_dist = nil
        for k,v in pairs(inst.tracking_parts) do
            if v:IsValid() and not v:IsInLimbo() then
                local dist = v:GetDistanceSqToInst(inst)
                if not closest_dist or dist < closest_dist then
                    closest = v
                    closest_dist = dist
                end
            end
        end

        return closest
    end

end

local function CheckTargetPiece(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner then
        local intensity = 0
        local closeness = nil
        local fxname = nil
        local target = FindClosestPart(inst) --FindEntity(inst, TUNING.DIVINING_MAXDIST, function(guy) return (guy:HasTag("teleportato") or guy:HasTag("teleportato_part") ) and not guy:IsInLimbo() end)
        local nextpingtime = TUNING.DIVINING_DEFAULTPING
        if target ~= nil then
            local distsq = inst.components.inventoryitem.owner:GetDistanceSqToInst(target)
            intensity = math.max(0, 1 - (distsq/(TUNING.DIVINING_MAXDIST*TUNING.DIVINING_MAXDIST) ))
            for k,v in ipairs(TUNING.DIVINING_DISTANCES) do
                closeness = v
                fxname = EFFECTS[v.describe]

                if v.maxdist and distsq <= v.maxdist*v.maxdist then
                    nextpingtime = closeness.pingtime
                    break
                end
            end
        end

        if closeness ~= inst.closeness then
            inst.closeness = closeness
            local desc = inst.components.inspectable:GetDescription(inst.components.inventoryitem.owner)
            if desc then
                inst.components.inventoryitem.owner.components.talker:Say(desc)
            end
        end

        if fxname ~= nil then
            --Don't care if there is still a reference to previous fx...
            --just let it finish on its own and remove itself
            inst.fx = SpawnPrefab(fxname)
            inst.fx.entity:AddFollower()
            inst.fx.Follower:FollowSymbol(inst.components.inventoryitem.owner.GUID, "swap_object", 80, -320, 0)
        end

        inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping", "ping")
        inst.SoundEmitter:SetParameter("ping", "intensity", intensity)
        inst.task = inst:DoTaskInTime(nextpingtime or 1, CheckTargetPiece)
    end 
end

local function onequip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("swap_object", "swap_diviningrod", "swap_diviningrod")
    if not inst.disabled then
        inst.closeness = nil 
        inst.tracking_parts = nil       
        inst.task = inst:DoTaskInTime(1, CheckTargetPiece)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if inst.fx ~= nil then
        if inst.fx:IsValid() then
            inst.fx:Remove()
        end
        inst.fx = nil
    end
    inst.closeness = nil
end

local function describe(inst)
    if inst.components.equippable:IsEquipped() then
        if inst.closeness and inst.closeness.describe then
            return string.upper(inst.closeness.describe)
        end
        return "COLD"
    end
end

local function OnSave(inst, data)
    data.disabled = inst.disabled
end

local function OnLoad(inst, data)
    if data then
        inst.disabled = data.disabled
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("diviningrod.png")

    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod")
    inst.AnimState:PlayAnimation("dropped")

    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")
    inst:AddTag("diviningrod")
    inst:AddTag("nopunch")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.Transform:SetScale(3,3,3)  ---大小

    inst:AddComponent("key")
    inst.components.key.keytype = LOCKTYPE.MAXWELL

    inst:AddComponent("inventoryitem")
    inst.components.inspectable.getstatus = describe
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.onpickupfn=function(inst,guy)
		if guy then
			guy:DoTaskInTime(0,function()
				if guy.components.inventory then
					guy.components.inventory:DropItem(inst)
				end
				SpawnPrefab("lightning")
				TheNet:Announce("魔尊二月红现身")
				local x, y, z = inst.Transform:GetWorldPosition()
		     	local r = SpawnPrefab("pigguard")
				r.Transform:SetPosition(x, 0, z)
				r.AnimState:SetBank("wilson")
				local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
				local buildname = names[math.random(#names)]
				r.AnimState:SetBuild("wilson") --------------------
				r.AnimState:PlayAnimation("idle")
				--local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
				--local wuqi = wuqis[math.random(#wuqis)]
				--r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
				--r.AnimState:Hide("ARM_normal") 
				--r.AnimState:Show("ARM_carry")
				local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
				local hat = hats[math.random(#hats)]
				r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
				r.AnimState:Show("HAT")
				r.AnimState:Show("HAT_HAIR")
				r.AnimState:Hide("HAIR_NOHAT")
				r.AnimState:Hide("HAIR")
				r.Transform:SetFourFaced()
				r.Transform:SetRotation( 0 )
				r.Transform:SetScale(2, 2, 2)
				local shadow = r.entity:AddDynamicShadow()
				shadow:SetSize( 2, 1.5 )
				r.components.inspectable:SetDescription("魔尊二月红")
				
				r:AddComponent("named")
				r.components.named:SetName("魔尊二月红")
				
				
				r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
				local light = r.entity:AddLight()
				light:SetFalloff(1)
				light:SetIntensity(.8)
				light:SetRadius(10)
				light:SetColour(180/255, 195/255, 50/255)
				light:Enable(true)
				r:AddTag("shadowboss")
				
				local function GetWeapon(r)
				if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
				local meleeweapon = CreateEntity()
				meleeweapon.entity:AddTransform()
				meleeweapon:AddComponent("weapon")
				meleeweapon.components.weapon:SetDamage(0)
				meleeweapon.components.weapon:SetRange(15, 19)
				meleeweapon.components.weapon:SetProjectile("zg_fx_luffyhand2")
				meleeweapon:AddComponent("inventoryitem")
				meleeweapon.persists = false
				meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
				meleeweapon:AddComponent("equippable")
				meleeweapon:AddTag("meleeweapon")
				r.components.inventory:Equip(meleeweapon)
				end
				end
				
				local function RetargetFn(r)
				local invader = nil
				invader = FindEntity(r, 10 + 25, function(guy)
					return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
				end)
				----	敌视语句
				if invader then
					local sayrandom = math.random()
					if sayrandom < .025 then
						if r.components.talker then
							r.components.talker:Say("我是要成为大魔尊的人!")
						end
					end
		
		
					if math.random() < .25 then
						----当和目标距离过大时使用橡胶手臂
						if not r:IsNear(invader, 10) then
							r.components.combat:SetTarget(invader)
							if not r.sg:HasStateTag("skill") then
								GetWeapon(r)
							end
						end
					end
		
				end
	
				return invader, true
				end
				local function KeepTargetFn(r, target)
					return r.components.combat:CanTarget(target)     
				end
				
				SetSharedLootTable( 'mozun',
                  {
				{'dragonpie',          1},
				{'dragonpie',          1},
				})
				
				r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
				r.components.eater.strongstomach = true
				local selfeater = r.components.eater
				local old = selfeater.Eat
				function r.components.eater:Eat(food)
					if selfeater:CanEat(food) then
						if food.components.edible.healthvalue < 1 then
							food.components.edible.healthvalue = 1
						end
					end
				return old(selfeater, food)
				end
	
				r:AddComponent("timer")
				
				r.components.locomotor.walkspeed= 2.5
				r.components.locomotor.runspeed = 3.5
				r.components.locomotor.fasteronroad = true
				r.components.locomotor:SetTriggersCreep(false)
				r:SetStateGraph("SGzg_ch2_luffy")

				local brain = require "brains/zg_ch_wolfgangbrain"
				r:SetBrain(brain)
				r.components.health:SetMaxHealth(20000)
				r.components.health:SetAbsorptionAmount(.7)
				r.components.combat:SetDefaultDamage( 150 )						
				r.components.combat:SetAttackPeriod( 2 )
				r.components.combat:SetRange(3)
				r.components.combat.hiteffectsymbol = "torso"
				r.components.combat:SetRetargetFunction(1, RetargetFn)
				r.components.combat:SetKeepTargetFunction(KeepTargetFn)
				
				r.components.combat:SetAreaDamage(2, 0.6)					----范围攻击
				function r.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
				local hitcount = 0
				local x, y, z = target.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"shadowboss"})			----AOE伤害忽略队友
				for i, ent in ipairs(ents) do
					if ent ~= target and
						ent ~= self.inst and
						self:IsValidTarget(ent) and
						(validfn == nil or validfn(ent)) then
						self.inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
						ent.components.combat:Zg_GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
						hitcount = hitcount + 1
					end
				end
				return hitcount
				end
				r:AddComponent("lootdropper")
				r.components.lootdropper:SetChanceLootTable('mozun')
							
				r.canzhanfu = true
				r.canpound = true
				r:ListenForEvent("timerdone", function (r, data)

					if data.name == "zhanfu" then
						r.canzhanfu = true
					elseif data.name == "pound" then
						r.canpound = true
					end
					
				end)
							
				
				
				
				
				
				
				
				
				inst:Remove()
			end)
		end
	end
	
	
	
	
	
	----------------c_give("diviningrod")

    inst:AddComponent("equippable")
	
	inst:AddComponent("named")
	inst.components.named:SetName("美人泪，英雄冢")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("diviningrod", fn, assets, prefabs)
