local assets =
{
    Asset("ANIM", "anim/myth_bbn.zip"),
	Asset("ATLAS", "images/inventoryimages/myth_bbn.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_bbn_full.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_bbnbutton.xml"),	
}

local prefabs =
{
    "positronbeam_front",
    --"positronpulse",
}

local function onremovelight(inst)
	if inst.moonlight ~= nil then
		inst:RemoveChild(inst.moonlight)
		inst.moonlight = nil
	end
	if inst.moontask then
		inst.moontask:Cancel()
		inst.moontask = nil
	end
end

local function onuse(inst,doer)
	if doer.components.myth_bbn_container ~= nil then
		return doer.components.myth_bbn_container:UseBnn(inst)
	end
	return true
end

local function onfull(inst)
	SpawnPrefab("halloween_moonpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.full = true
	inst.AnimState:PlayAnimation("full")
    inst:AddComponent("myth_use_inventory")
	inst.components.myth_use_inventory.canuse = true
	inst.components.myth_use_inventory:SetOnUseFn(onuse)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bbn_full.xml"
	inst.components.inventoryitem:ChangeImageName("myth_bbn_full")
end

local function ondone(inst)
	inst.moontask = nil
	onremovelight(inst)
	onfull(inst)
end

local function oncreatlight(inst)
	inst.moonlight = inst:SpawnChild("positronbeam_front")
	inst.moonlight.Transform:SetPosition(-0.2, -1.4, 0)	
	inst.moontask = inst:DoTaskInTime(6,ondone)
end

local function OnPickup(inst)
	onremovelight(inst)
end

local function CheckForFull(inst)
	if not inst.full and TheWorld.state.isfullmoon then
		local owner = inst.components.inventoryitem.owner
		if owner == nil then
			oncreatlight(inst)
		end
	end
end

local function OnDrop(inst)
	CheckForFull(inst)
end
local function onload(inst, data)
    if data ~= nil and data.full then
        onfull(inst)
    end
end

local function onsave(inst, data)
    data.full = inst.full
end

local function onopen(inst)
end

local function onclose(inst)

end
--DebugSpawn"myth_bbn":OnFull()

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_bbn")
    inst.AnimState:SetBuild("myth_bbn")
    inst.AnimState:PlayAnimation("empty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.full = false
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bbn.xml"
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)
	inst.components.inventoryitem:SetOnDroppedFn(OnDrop)

	inst:WatchWorldState("isfullmoon", CheckForFull)
	inst:WatchWorldState("startday", function() 
		onremovelight(inst)
	end)
	
	inst.OnFull = onfull
    inst.OnSave = onsave
    inst.OnLoad = onload
	
    return inst
end

local function OnUpdate(self,dt)
    if self.opencount == 0 then
        self.inst:StopUpdatingComponent(self)
    else
        for opener, _ in pairs(self.openlist) do
            if not (self.inst.components.inventoryitem ~= nil and
                    self.inst.components.inventoryitem:IsHeldBy(opener)) and
                    (
                    not (opener:IsNear(self.inst, 3) and
                    CanEntitySeeTarget(opener, self.inst))) then
                self:Close(opener)
            end
        end
    end
end
local function containerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst:AddTag("fridge")
	inst:AddTag("nocool")
	inst:AddTag("CLASSIFIED")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("myth_bbn") 
		end
        return inst
    end
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("myth_bbn")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	inst.components.container.OnUpdate = OnUpdate
	return inst
end
return Prefab("myth_bbn", fn, assets,prefabs),
	Prefab("myth_bbn_container", containerfn)
