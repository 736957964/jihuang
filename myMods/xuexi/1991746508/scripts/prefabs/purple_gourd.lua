require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/purple_gourd.zip"),
    Asset("ATLAS", "images/inventoryimages/purple_gourd.xml"),
}

-- local L = MK_MOD_LANGUAGE_SETTING

local function consuming(inst,stop)
    local container = inst.components.container
    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item and item.components.fueled and item:HasTag("mk_pills") then
            if stop then
                item.components.fueled:StopConsuming()
            else
                item.components.fueled:StartConsuming()
            end
        end
    end
end

local function onopen(inst)
    consuming(inst,false)
    --inst.SoundEmitter:PlaySound("malibag/malibag/open")
end

local function onclose(inst)
    consuming(inst,true)
    --inst.SoundEmitter:PlaySound("malibag/malibag/close")
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function onload(inst) --重进游戏停止掉耐久
    if not inst.components.container:IsOpen() then
        consuming(inst,true)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "purple_gourd", "swap_2")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    for r = 5, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        --if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
		if  not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function Absorb(inst, doer, pos)
    -- doer:PushEvent("purple_gourd_abosrb", {targetpos = pos, weapon = inst})
    inst:DoAbsorb(pos)
    inst.components.rechargeable:StartRecharging()
end

local function DoAbsorb(inst, pos)
    local r = 8
    local x,y,z = pos:Get()
    local ents = TheSim:FindEntities(x,y,z,r,nil, {"epic","friendlyfruitfly","INLIMBO","FX","fire"},{"_inventoryitem","myth_small_goldfrog","player","fruitfly","canbetrapped"})
    for _,v in ipairs(ents)do
        local pt = v:GetPosition()
		if v:HasTag("player") then
			if v._underground and v._underground:value() and v.OnUseBh then
				v:OnUseBh()
			end
		else
			if v.components.health then
				if v.prefab == "myth_small_goldfrog" then --金蟾
					if not v.components.health:IsDead() then
						SpawnPrefab("sand_puff").Transform:SetPosition(pt:Get())
						v:Remove()
						if math.random() < 0.5 then
							local new = SpawnPrefab(math.random() < 0.5 and "myth_coin" or "lucky_goldnugget" )
							inst.components.container:GiveItem(new, nil, nil, false)
						end
					end
                elseif v:HasTag("canbetrapped") then
                    if not v.components.health:IsDead() then
                        local getloots = {}
                        if v.components.inventoryitem ~= nil then
                            if v.settrapdata then
                                getloots = v.settrapdata(v)
                                v:Remove()
                            elseif inst.components.container:GiveItem(v, nil, nil, false) then
                                SpawnPrefab("sand_puff").Transform:SetPosition(pt:Get())
                            end
                        elseif v.components.lootdropper ~= nil then
                            getloots = v.components.lootdropper:GenerateLoot() or { "spoiled_food" }
                            v:Remove()
                        end
                        for _,v1 in ipairs(getloots) do
                            local item = SpawnPrefab(v1)
                            if item then
                                inst.components.container:GiveItem(item, nil, nil, false)
                            end
                        end
                    end
                elseif v.prefab == "fruitfly" then --果蝇
					if not v.components.health:IsDead() then
						SpawnPrefab("sand_puff").Transform:SetPosition(pt:Get())
						v:Remove()
						local new = SpawnPrefab("seeds")
						inst.components.container:GiveItem(new, nil, nil, false)
					end
				else
					local pd = v:GetPersistData()
					local new = SpawnPrefab(v.prefab)--崩了别怪我 
					if new then
						new:SetPersistData(pd, {})
						if inst.components.container:GiveItem(new, nil, nil, false) then
							SpawnPrefab("sand_puff").Transform:SetPosition(pt:Get())
							v:Remove()
						else
							new:Remove()
						end
					end
				end
			elseif v.prefab ~= "bullkelp_beachedroot" and not v:HasTag("trap") then
				if inst.components.container:GiveItem(v, nil, nil, false) then
					SpawnPrefab("sand_puff").Transform:SetPosition(pt:Get())
				end
			end
		end
    end

    local doer = inst.components.inventoryitem.owner
    if doer then
        if doer.components.hunger then
            doer.components.hunger:DoDelta(-10)
        end
        if doer.components.sanity then
            doer.components.sanity:DoDelta(-10)
        end
    end
end

local function SetType(inst, tp)
    if tp == "MALE" then
        inst.components.named:SetName(STRINGS.NAMES.PURPLE_GOURD_MALE)
    elseif tp == "FEMALE" then
        inst.components.named:SetName(STRINGS.NAMES.PURPLE_GOURD_FEMALE)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("purple_gourd")
    inst.AnimState:SetBuild("purple_gourd")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("purple_gourd")
    inst:AddTag("rechargeable")
    inst:AddTag("nopunch")
    -- inst:AddTag("irreplaceable")
    inst:AddTag("_named")
	
	MakeInventoryFloatable(inst)

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetRange(16)
    inst.components.aoetargeting.reticule.reticuleprefab = "purple_gourd_re"
    inst.components.aoetargeting.reticule.pingprefab = "purple_gourd_re2"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true   
	inst.components.aoetargeting.alwaysvalid = true 
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:RemoveTag("_named")

    inst:AddComponent("named")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.canonlygoinpocket = true
	inst.components.inventoryitem.atlasname = "images/inventoryimages/purple_gourd.xml"
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("purple_gourd")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

	inst:AddComponent("myth_aoespell")
    inst.components.aoespell = inst.components.myth_aoespell
	inst.components.aoespell:SetSpellFn(Absorb)
	inst.components.aoespell.ispassableatallpoints = true
	inst:RegisterComponentActions("aoespell")
	
	inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
	inst.components.rechargeable:SetRechargeTime(5)
	inst:RegisterComponentActions("rechargeable")

    inst.DoAbsorb = DoAbsorb
    inst.SetType = SetType
	
    inst:DoTaskInTime(0, onload)

    return inst
end

--右键技能范围特效(名字,实体,大小)
local function makeaoe(name, fx, size)
    local function fn()
        local inst = SpawnPrefab(fx)
        inst.AnimState:SetScale(size, size)
        return inst
    end

    return Prefab(name, fn)
end

return Prefab("purple_gourd", fn, assets),
    makeaoe("purple_gourd_re", "reticuleaoe", 2.6),
    makeaoe("purple_gourd_re2", "reticuleaoeping", 2.6),
    makeaoe("purple_gourd_re3", "reticuleaoe", 1.1),
    makeaoe("purple_gourd_re4", "reticuleaoeping", 1.1)