require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/pill_bottle_gourd.zip"),
}

local function consuming(inst,stop)
	local container = inst.components.container
    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item and item.components.fueled then
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("pill_bottle_gourd")
    inst.AnimState:SetBuild("pill_bottle_gourd")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("pill_bottle_gourd")
	
	MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.canonlygoinpocket = true
	inst.components.inventoryitem.atlasname = "images/monkey_king_item.xml"
	
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("pill_bottle_gourd")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

	inst:DoTaskInTime(0, onload) --重载用的
    return inst
end

local function bb()
    local inst = SpawnPrefab('pill_bottle_gourd')
    if not TheWorld.ismastersim then
        return inst
    end
    
    local pillchoice = {
        'fly_pill', 'bloodthirsty_pill', 'condensed_pill', 'armor_pill',
    }
    for _, v in ipairs(pillchoice)do
        local num = math.random(2)
        for i = 1, num do
            local pill = SpawnPrefab(v)
            inst.components.container:GiveItem(pill)
        end
    end
    consuming(inst, false)
    return inst
end

return Prefab("pill_bottle_gourd", fn, assets), Prefab('pill_bottle_gourd_bb', bb)

