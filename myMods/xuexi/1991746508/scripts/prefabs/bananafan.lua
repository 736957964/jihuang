local assets =
{
    Asset("ANIM", "anim/bananafan.zip"),
	Asset("ATLAS", "images/inventoryimages/bananafan.xml")
}

local prefabs =
{

}

local function OnUse(inst, target)
	TheWorld:PushEvent("ms_deltamoisture", TUNING.TELESTAFF_MOISTURE)
	TheWorld.bananafanuse = (TheWorld.bananafanuse or 0) +1
 	if TheWorld.bananafanuse == 3 then
		TheWorld.bananafanuse  = 0
		if  not TheWorld.state.israining then 
			TheWorld:PushEvent("ms_forceprecipitation", true)
		end   
	end
	local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 32, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, {"myth_rhino_fx","smolder", "fire", "player","alchmy_fur" })
    for i, v in pairs(ents) do
        if  v.DestroyByFan then
            v:DestroyByFan()
        end
        if v.components.burnable ~= nil then
				if v.components.burnable:IsBurning() then
					v.components.burnable:Extinguish()
				elseif v.components.burnable:IsSmoldering() then
					v.components.burnable:SmotherSmolder()
				end
        end
        if v.components.temperature ~= nil then
            v.components.temperature:DoDelta(math.clamp(TUNING.FEATHERFAN_MINIMUM_TEMP - v.components.temperature:GetCurrent(), TUNING.FEATHERFAN_COOLING, 0))
        end
        if v.components.stewer_fur ~= nil and v.components.stewer_fur:IsCooking() then
            v.components.stewer_fur:DoneCooking()
        end		
		
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bananafan")
    inst.AnimState:SetBuild("bananafan")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fan")
	
	local swap_data = {sym_build = "bananafan",sym_name = "water"}

	MakeInventoryFloatable(inst, "large", 0.05, {0.6, 0.35, 0.6}, true, -10, swap_data)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bananafan.xml"

    inst:AddComponent("fan")
    inst.components.fan:SetOnUseFn(OnUse)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.FAN, 1)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("bananafan", fn, assets)
