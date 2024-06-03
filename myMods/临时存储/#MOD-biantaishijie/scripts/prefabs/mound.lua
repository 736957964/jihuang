local assets =
{
    Asset("ANIM", "anim/gravestones.zip"),
}

local prefabs =
{
    "ghost",
    "amulet",
    "redgem",
    "gears",
    "bluegem",
    "nightmarefuel",
}

for k = 1, NUM_TRINKETS do
    table.insert(prefabs, "trinket_"..tostring(k))
end

local LOOTS =
{
    nightmarefuel = 1,
    amulet        = 1,
    gears         = 1,
    redgem        = 5,
    bluegem       = 5,
	
}

local function ReturnChildren(inst)
    local toremove = {}
    for k, v in pairs(inst.components.childspawner.childrenoutside) do
        table.insert(toremove, v)
    end
    for i, v in ipairs(toremove) do
        if v:IsAsleep() then
            v:PushEvent("detachchild")
            v:Remove()
        else
            v.components.health:Kill()
        end
    end
end

local function spawnghost(inst, chance)
    if inst.ghost == nil and math.random() <= (chance or 1) then
        inst.ghost = SpawnPrefab("ghost")
        if inst.ghost ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.ghost.Transform:SetPosition(x - .3, y, z - .3)
            inst:ListenForEvent("onremove", function() inst.ghost = nil end, inst.ghost)
            return true
        end
    end
    return false
end

----------------------------------------------------------------------------------修改
local function CHUXIAN()
	local ground = TheWorld
	local centers = {}
	for i, node in ipairs(ground.topology.nodes) do
		if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
			table.insert(centers, {x = node.x, z = node.y})
		end
	end
	if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return nil
	end
end



local function onfinishcallback(inst, worker)
	
	local  jilv = math.random()
    local x, y, z = inst.Transform:GetWorldPosition()
	
	
	if     jilv < 0.1 then 
		SpawnPrefab("deerclops").Transform:SetPosition(x-5, 0, z+5)
	elseif jilv < 0.12 then 
		SpawnPrefab("minotaur").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.14 then 
		SpawnPrefab("worm").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.16 then 
		SpawnPrefab("bearger").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.18 then 
		SpawnPrefab("dragonfly").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.20 then 
		SpawnPrefab("mossling").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.22 then 
		SpawnPrefab("krampus").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.24 then 
		SpawnPrefab("moose").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.26 then 
		SpawnPrefab("leif").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.28 then 
		SpawnPrefab("koalefant_summer").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.3 then 
		SpawnPrefab("rocky").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.32 then 
		SpawnPrefab("slurper").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.34 then 
		SpawnPrefab("bishop").Transform:SetPosition(x, 0, z)
	elseif jilv < 0.36 then 
		SpawnPrefab("rook").Transform:SetPosition(x, 0, z)
	else 
	    SpawnPrefab("pigman").Transform:SetPosition(x, 0, z)
	end
		
	inst:Remove()
	
	
	local pos = CHUXIAN()
	if pos then
	----SpawnPrefab("mound").Transform:SetPosition( pos:Get() )
	end
end


------------------------------------------------------------------------------------修改

local function onfullmoon(inst, isfullmoon)
    if isfullmoon then
        inst.components.childspawner:StartSpawning()
        inst.components.childspawner:StopRegen()
    else
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StartRegen()
        ReturnChildren(inst)
    end
end

local function GetStatus(inst)
    if not inst.components.workable then
        return "DUG"
    end
end

local function OnSave(inst, data)
    if inst.components.workable == nil then
        data.dug = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.dug or inst.components.workable == nil then
        inst:RemoveComponent("workable")
        inst.AnimState:PlayAnimation("dug")
    end
end

local function OnHaunt(inst, haunter)
    --#HAUNTFIX
    --return spawnghost(inst, TUNING.HAUNT_CHANCE_HALF)
    return true
end

local function oninit(inst)
    inst:WatchWorldState("isfullmoon", onfullmoon)
    onfullmoon(inst, TheWorld.state.isfullmoon)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("gravestone")
    inst.AnimState:SetBuild("gravestones")
    inst.AnimState:PlayAnimation("gravedirt")

    inst:AddTag("grave")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst:AddComponent("lootdropper")

    inst.components.workable:SetOnFinishCallback(onfinishcallback)

    inst.ghost = nil

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "ghost"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(10, 3)

    inst:DoTaskInTime(0, oninit)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("mound", fn, assets, prefabs)
