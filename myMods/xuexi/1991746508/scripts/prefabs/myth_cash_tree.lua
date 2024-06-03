require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/myth_cash_tree.zip"),
    Asset("ATLAS", "images/inventoryimages/myth_cash_tree_ground.xml"),
    Asset("ATLAS", "images/inventoryimages/myth_cash_tree.xml"),
}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
	
	inst.components.lootdropper:SpawnLootPrefab("myth_cash_tree")
	
	local coin = inst.components.lootdropper:SpawnLootPrefab("myth_coin")
	if coin and coin.components.stackable then
		coin.components.stackable:SetStackSize(33)
	end
	local lucky_goldnugget = inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
	if lucky_goldnugget and coin.components.stackable then
		lucky_goldnugget.components.stackable:SetStackSize(33)
	end
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("crash")
	inst.AnimState:PushAnimation("ground")
end
	
local gems = {"purplegem","bluegem","redgem","orangegem","yellowgem","greengem"}
	
local prizevalues = 
{
	myth_coin = 0.7,
	gem = 0.05,
	lucky_goldnugget = 0.7,
	goldnugget = 0.25,
}

local function getspawn(self)
	local prizevalue = weighted_random_choice(prizevalues)
	if prizevalue  then
		if prizevalue == "gem" then
			return gems[math.random(#gems)]
		else
			return prizevalue
		end
	end
	return "myth_coin"
end

local function onspawn(inst,prefab)
	inst.AnimState:PlayAnimation("crash")
	inst.AnimState:PushAnimation("ground")
	--哗哗哗的音效呢
	inst:DoTaskInTime(0.5, function(inst) 
		inst.components.lootdropper:SpawnLootPrefab(prefab)
	end)
end

local function TrySpawn(self,...)
    local prefab = getspawn(self)

    if not (prefab and self.inst:IsValid()) or
        (self.spawnoffscreen and not self.inst:IsAsleep()) or
        (self.spawntest ~= nil and not self.spawntest(self.inst)) then
        return false
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()

    if self.range ~= nil then
        local density = self.density or 0
        if density <= 0 then
            return false
        end

        local ents = TheSim:FindEntities(x, y, z, self.range,nil,{"INLIMBO",},{"gem","myth_coin"})
        local count = 0
        for i, v in ipairs(ents) do
            if v and v:IsValid() then
				count = count + 1
                if count >= density then
                    return false
                end
            end
        end
    end   
    if self.onspawn ~= nil then
        self.onspawn(self.inst, prefab)
    end    
    return true
end

local function shine(inst)
    inst.task = nil
	local x = math.random()*2 -1 local y = 2.5+math.random()*2 -1
	inst.sparkle.Transform:SetPosition(x, y,0 )
    inst.sparkle.AnimState:PlayAnimation("sparkle")
    inst.task = inst:DoTaskInTime(2 + math.random() * 3, shine)
	if math.random() < 0.6 then
		inst:DoTaskInTime(1 + math.random(),function()
			local x = math.random()*2 -1 local y = 2.5+math.random()*2 -1
			inst.sparkle.Transform:SetPosition(x, y,0 )
			inst.sparkle.AnimState:PlayAnimation("sparkle")
		end)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_cash_tree_ground.tex")

    inst:AddTag("structure")

	MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("myth_cash_tree")
    inst.AnimState:SetBuild("myth_cash_tree")
    inst.AnimState:PlayAnimation("ground")

	inst.Transform:SetScale(1.2, 1.2, 1.2)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	--inst.AnimState:SetLightOverride(0.2)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("goldnugget")
    inst.components.periodicspawner:SetRandomTimes(450, 60)
    inst.components.periodicspawner:SetDensityInRange(4, 20)
    inst.components.periodicspawner:SetMinimumSpacing(8)
	inst.components.periodicspawner.TrySpawn = TrySpawn
	inst.components.periodicspawner.onspawn = onspawn
    inst.components.periodicspawner:Start()
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = 25/60
	
	inst.sparkle = inst:SpawnChild("myth_cash_tree_sparkle") 
	shine(inst)
	
    return inst
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_cash_tree")
    inst.AnimState:SetBuild("myth_cash_tree")
    inst.AnimState:PlayAnimation("idle")

	MakeInventoryPhysics(inst)
	
	MakeInventoryFloatable(inst)
	
	inst:AddTag("irreplaceable")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_cash_tree.xml"
    --inst.components.inventoryitem.nobounce = true

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddFollower()

    inst.AnimState:SetBank("goldnugget")
    inst.AnimState:SetBuild("gold_nugget")
    inst.AnimState:PlayAnimation("sparkle",true)

	inst.AnimState:HideSymbol("nugget")
	
	inst:AddTag("fx")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.persists = false

    return inst
end
return Prefab("myth_cash_tree_ground", fn, assets, prefabs),
	Prefab("myth_cash_tree", itemfn, assets),
	Prefab("myth_cash_tree_sparkle", fxfn),
    MakePlacer("myth_cash_tree_ground_placer", "myth_cash_tree", "myth_cash_tree", "ground",nil,nil,nil,1.2)
