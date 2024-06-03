
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	

--------分解--------
local function destroystructure(staff, target)
    local recipe = AllRecipes[target.prefab]
    if recipe == nil then
        --Action filters should prevent us from reaching here normally
        return
    end
------------------------------修改
    if target:HasTag("wufafenjie") then return end
    local ingredient_percent = (target.components.armor ~= nil and target.components.inventoryitem ~= nil and target.components.armor:GetPercent()) 
	or (target.components.fueled ~= nil and target.components.inventoryitem ~= nil and target.components.fueled:GetPercent()) 
	or (target.components.finiteuses ~= nil and target.components.finiteuses:GetPercent()) 
	or 1
        
    local caster = staff.components.inventoryitem.owner

------------------------------修改
    if caster ~= nil then
        caster.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")

        if caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-5)--修改	
			caster.components.talker:Say("分解？不存在的~")
			
        end
    end

    staff.components.finiteuses:Use(1)

    if target.components.inventory ~= nil then
        target.components.inventory:DropEverything()
    end

    if target.components.container ~= nil then
        target.components.container:DropEverything()
    end

    if target.components.spawner ~= nil and target.components.spawner:IsOccupied() then
        target.components.spawner:ReleaseChild()
    end

    if target.components.occupiable ~= nil and target.components.occupiable:IsOccupied() then
        local item = target.components.occupiable:Harvest()
        if item ~= nil then
            item.Transform:SetPosition(target.Transform:GetWorldPosition())
            item.components.inventoryitem:OnDropped()
        end
    end

    if target.components.trap ~= nil then
        target.components.trap:Harvest()
    end

    if target.components.dryer ~= nil then
        target.components.dryer:DropItem()
    end

    if target.components.harvestable ~= nil then
        target.components.harvestable:Harvest()
    end

    if target.components.stewer ~= nil then
        target.components.stewer:Harvest()
    end

   	target:PushEvent("ondeconstrcutstructure", caster)

    if target.components.stackable ~= nil then
        target.components.stackable:Get():Remove()
    else
        target:Remove()
    end
end

local function onhauntgreen(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_RARE then
        local target = FindEntity(inst, 20, HasRecipe, nil, { "INLIMBO" })
        if target ~= nil then
            destroystructure(inst, target) 
            SpawnPrefab("collapse_small").Transform:SetPosition(target.Transform:GetWorldPosition())
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_LARGE
            return true
        end
    end
    return false
end

AddPrefabPostInit("greenstaff",function(inst)
    if not _G.TheWorld.ismastersim then return inst end           
    inst.components.spellcaster:SetSpellFn(destroystructure)
    AddHauntableCustomReaction(inst, onhauntgreen, true, false, true)

end)





---懒惰强盗
local function pickup(inst, owner)
    -----------------------------------修改 周围有玩家无效
    if owner == nil or owner.components.inventory == nil then return end
    if owner:HasTag("playerghost") then return end
    local p1x, p1y, p1z = owner.Transform:GetWorldPosition()
    for i, player in ipairs(AllPlayers) do
        local p2x, p2y, p2z = player.Transform:GetWorldPosition()
        local cc = math.sqrt((p1x-p2x)*(p1x-p2x)+(p1z-p2z)*(p1z-p2z))
        if cc < 6 and owner ~= player then return end
    end
    
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.ORANGEAMULET_RANGE, {  }, { "INLIMBO", "NOCLICK", "catchable", "fire" })--修改
    for i, v in ipairs(ents) do
            if v.components.pickable and v.components.pickable:CanBePicked() then
                local fx = SpawnPrefab("small_puff")
                fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                fx.Transform:SetScale(.5, .5, .5)
                inst.components.finiteuses:Use(3)
                v.components.pickable:Pick(owner)
                return
            elseif v.shangdianzhanshi == nil and v.components.stackable ~= nil and v.components.inventoryitem ~= nil and v.components.inventoryitem.canbepickedup and not v.components.inventoryitem:IsHeld() and owner.components.inventory:CanAcceptCount(v, 1) > 0 then
                local fx = SpawnPrefab("small_puff")
                fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                fx.Transform:SetScale(.5, .5, .5)
                inst.components.finiteuses:Use(1)
                owner.components.inventory:GiveItem(v.components.stackable:Get())
                return
            end
    end
    -----------------------------------修改
end

local function onequip_orange(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "orangeamulet")
    inst.task = inst:DoPeriodicTask(1, pickup, nil, owner)
end

local function onunequip_orange(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

AddPrefabPostInit("orangeamulet",function(inst)
    if not _G.TheWorld.ismastersim then return inst end --非主机则不加载
    inst.components.equippable:SetOnEquip(onequip_orange)
    inst.components.equippable:SetOnUnequip(onunequip_orange)
end)