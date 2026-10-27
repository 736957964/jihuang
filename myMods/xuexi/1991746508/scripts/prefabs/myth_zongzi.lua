
local function OnDropped(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    if  TheWorld.Map:IsOceanAtPoint(x, y, z) then
        SpawnPrefab("splash_green").Transform:SetPosition(x, y, z)
        SpawnPrefab("chum_aoe").Transform:SetPosition(x, y, z)
		inst:Remove()
    end
end

local PROJECTILE_COLLISION_MASK = COLLISION.GROUND

local function OnHit(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
        --SpawnPrefab(inst.prefab).Transform:SetPosition(x, y, z)
    else
        SpawnPrefab("splash_green").Transform:SetPosition(x, y, z)
        SpawnPrefab("chum_aoe").Transform:SetPosition(x, y, z)
    end
	if inst.prefab == "myth_zongzi2" then
		if  math.random() < 0.4 then
			local offset = FindWalkableOffset(inst:GetPosition(), math.random() * 2 * PI, 4, 10)
			if offset ~= nil then
				x = x + offset.x
				z = z + offset.z	
			end
			SpawnPrefab("wobster_sheller_land").Transform:SetPosition(x, 0, z)
		end
		if math.random() < 0.1 then
			local offset = FindWalkableOffset(inst:GetPosition(), math.random() * 2 * PI, 4, 10)
			if offset ~= nil then
				x = x + offset.x
				z = z + offset.z	
			end	
			SpawnPrefab("gnarwail").Transform:SetPosition(x, 0, z)			
		end
	end

    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_myth_zongzi", inst.prefab)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:PlayAnimation("spin_loop",true)
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetCollisionMask(PROJECTILE_COLLISION_MASK)
    inst.Physics:SetCapsule(.2, .2)
end

local function OnAddProjectile(inst)
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHit)
end
local function ReticuleTargetFn()
    local pos = Vector3()
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = ThePlayer.entity:LocalToWorldSpace(r, 0, 0)
        if TheWorld.Map:IsOceanAtPoint(pos.x, pos.y, pos.z, false) then
            return pos
        end
    end
    return pos
end

local function MakeZongzi(name, idle, prefab,caneat,meat)
    local assets =
    {
        Asset("ANIM", "anim/myth_zongzi.zip"),
        Asset("ANIM", "anim/swap_myth_zongzi.zip"),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),
    }

    local prefabs =
    {
        prefab,
    }
    local function OnUnwrapped(inst, pos, doer)
        if inst.burnt then
            SpawnPrefab("ash").Transform:SetPosition(pos:Get())
        else
            local moisture = inst.components.inventoryitem:GetMoisture()
            local iswet = inst.components.inventoryitem:IsWet()
            local item = SpawnPrefab(prefab)
            if item ~= nil then
				if doer and doer.components.inventory then
					 doer.components.inventory:GiveItem(item)
				else
					if item.Physics ~= nil then
						item.Physics:Teleport(pos:Get())
					else
						item.Transform:SetPosition(pos:Get())
					end
				end
				if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:InheritMoisture(moisture, iswet)
				end
			end
            SpawnPrefab("myth_bundle_unwrap").Transform:SetPosition(pos:Get())
        end
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
        inst:Remove()
    end
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("myth_zongzi")
        inst.AnimState:SetBuild("myth_zongzi")
        inst.AnimState:PlayAnimation(idle)
		
		if caneat then
            inst:AddTag("preparedfood")
            inst:AddTag("myth_zongzi")
		else
			inst:AddComponent("reticule")
			inst.components.reticule.targetfn = ReticuleTargetFn
			inst.components.reticule.ease = true

			inst:AddTag("allow_action_on_impassable")
		end
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		
        inst:AddComponent("inspectable")
		
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
		
		if caneat then
			inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize =TUNING.STACK_SIZE_LARGEITEM
			inst:AddComponent("edible")
			inst:AddComponent("perishable")
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = "spoiled_food"
			if meat then
				inst.components.edible.foodtype = FOODTYPE.MEAT
				inst.components.edible.healthvalue = 3
				inst.components.edible.hungervalue = 62.5
				inst.components.edible.sanityvalue = 5	
				inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
			else
				inst.components.edible.foodtype = FOODTYPE.VEGGIE
				inst.components.edible.hungervalue = 75
				inst.components.perishable:SetPerishTime(TUNING.AUTOSAVE_INTERVAL* 10)
			end
			inst:DoTaskInTime(0.1, OnDropped)
		else
			--可装备组件
			inst:AddComponent("unwrappable")
			inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
			
			inst:AddComponent("oceanthrowable")
			inst.components.oceanthrowable:SetOnAddProjectileFn(OnAddProjectile)
			
			inst:AddComponent("equippable")
			inst.components.equippable:SetOnEquip(onequip)
			inst.components.equippable:SetOnUnequip(onunequip)
		end
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeZongzi("myth_zongzi1", "idle1", "myth_zongzi_item1"),
	MakeZongzi("myth_zongzi2", "idle2", "myth_zongzi_item2"),
	MakeZongzi("myth_zongzi_item1", "item1", nil,true,false),
	MakeZongzi("myth_zongzi_item2", "item2", nil,true,true)