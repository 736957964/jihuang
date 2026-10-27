local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}


local function dmxy(inst)
local pos = Vector3(inst.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
	for k,v in pairs(ents) do
		if v.components.workable ~= nil and v.components.workable.workleft > 0 and v:HasTag("boulder") or v.components.workable ~= nil and v.components.workable.workleft > 0 and v:HasTag("tree")  then
			v.components.workable:Destroy(inst)
		
	end
end
end

local function dmxx(inst ,owner)
if owner == nil or owner.components.inventory == nil then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 8, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire", "minesprung", "mineactive" })
    for i, v in ipairs(ents) do
        if v.components.inventoryitem ~= nil and
            v.components.inventoryitem.canbepickedup and
            v.components.inventoryitem.cangoincontainer and
            not v.components.inventoryitem:IsHeld() and
            owner.components.inventory:CanAcceptCount(v, 1) > 0 then

            local v_pos = v:GetPosition()
            if v.components.stackable ~= nil then
                v = v.components.stackable:Get()
            end

            if v.components.trap ~= nil and v.components.trap:IsSprung() then
                v.components.trap:Harvest(owner)
            else
                owner.components.inventory:GiveItem(v, nil, v_pos)
            end
            return
        end
    end

			local enta = TheSim:FindEntities(x,y,z,8, nil,nil,{"pickable","harvestable"})
                 if    false     then      --------这可以写true  则能采集花
					for i,v in pairs(enta) do
						if v.components.pickable  then 
						
						v.components.pickable:Pick(owner)
               
						elseif v.components.harvestable then
							v.components.harvestable:Harvest(owner)
						end
						end
						else
						for i,v in pairs(enta) do
						if v.components.pickable and not v:HasTag("flower")  and not v:HasTag("thorny")and not v:HasTag("cactus")then
						v.components.pickable:Pick(owner)
               
						elseif v.components.harvestable then
							v.components.harvestable:Harvest(owner)
						end
						end
            end
	
	
end







local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_cane", inst.GUID, "swap_cane")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
    end
	if  owner and owner.components.builder then 
    owner.components.builder:GiveAllRecipes()
	end
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	inst.task = inst:DoPeriodicTask(1, function() dmxy(inst) end)
	inst.task2 = inst:DoPeriodicTask(.1, function() dmxx(inst ,owner) end)
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
	if  owner and owner.components.builder then 
    owner.components.builder:GiveAllRecipes()
	end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	if inst.task then inst.task:Cancel() inst.task = nil end
	if inst.task2 then inst.task2:Cancel() inst.task2 = nil end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(1000)
	inst.components.weapon:SetRange(16,20)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
	inst:AddComponent("builder")
	if  inst.components.named == nil  then   
		inst:AddComponent("named")
		inst.components.named:SetName("全物品制造手杖\r自动砍树和挖矿\r自动采集和捡取\r二月红自动时代\r二月红测试专用")
	end
    inst:AddComponent("blinkstaff")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.8

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("cane", fn, assets)
