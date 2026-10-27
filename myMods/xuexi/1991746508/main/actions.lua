local L = MK_MOD_LANGUAGE_SETTING
local V = L == "VI" and true or false
--------------------- 炼丹炉 ----------------------
--炼丹炉.取丹
local  FUR_HARVEST = Action({mount_valid = true})
FUR_HARVEST.id = "FUR_HARVEST"
FUR_HARVEST.str = STRINGS.FUR_HARVEST
FUR_HARVEST.fn = function(act)
    if act.target.components.stewer_fur ~= nil then
        return act.target.components.stewer_fur:Harvest(act.doer)
	end
end

--炼丹炉.炼丹
local  FUR_COOK = Action({ priority=1, mount_valid=true })
FUR_COOK.id = "FUR_COOK"
FUR_COOK.str = STRINGS.FUR_COOK
FUR_COOK.fn = function(act)
    if act.target.components.stewer_fur ~= nil then
        if act.target.components.stewer_fur:IsCooking() then
            return true
        end
        local container = act.target.components.container
        if container ~= nil and container:IsOpen() and not container:IsOpenedBy(act.doer) then
            return false, "INUSE"
        elseif not act.target.components.stewer_fur:CanCook() then
            return false
        end
        act.target.components.stewer_fur:StartCooking()
        return true
    end
end

AddAction(FUR_COOK)
AddAction(FUR_HARVEST)

AddComponentAction("SCENE", "stewer_fur" , function(inst, doer, actions, right)
    if not inst:HasTag("burnt") and
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
        if inst:HasTag("donecooking_fur") then
            table.insert(actions, ACTIONS.FUR_HARVEST)
        elseif right and
            (inst:HasTag("readytocook_fur")
            or (inst.replica.container ~= nil and
                inst.replica.container:IsFull() and
                inst.replica.container:IsOpenedBy(doer))) then
            table.insert(actions, ACTIONS.FUR_COOK)
            end
        end
end) 

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.FUR_COOK, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.FUR_COOK, "dolongaction"))

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.FUR_HARVEST, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.FUR_HARVEST, "dolongaction"))

--------------------------- 酒 ---------------------------
--倒酒(魔改fuel组件, 真偷懒)
FUELTYPE.GOURDWINE = "GOURDWINE"
local oldfn = ACTIONS.ADDFUEL.strfn or function() return 'ADDFUEL' end
ACTIONS.ADDFUEL.strfn = function(act)
    if act.invobject and act.invobject.prefab == "peach_wine" then
        return "GOURD"
    else
        return oldfn(act)
    end
end
local oldstr = STRINGS.ACTIONS.ADDFUEL
if type(oldstr) == 'string' then 
    STRINGS.ACTIONS.ADDFUEL = {ADDFUEL = oldstr}
end

if L == "CHINESE" then
    STRINGS.ACTIONS.ADDFUEL.GOURD = '满上!'
elseif L == "JAPAN" then
    STRINGS.ACTIONS.ADDFUEL.GOURD = '注入する'
elseif V then
    STRINGS.ACTIONS.ADDFUEL.GOURD = 'Thêm rượu!'
else
    STRINGS.ACTIONS.ADDFUEL.GOURD = 'Add wine'
end

--右键使用的动作(包括两种 一种是在物品栏 一种是地上的)
local  MYTH_USE_INVENTORY = Action({ priority=1,mount_valid=true })
MYTH_USE_INVENTORY.id = "MYTH_USE_INVENTORY"
MYTH_USE_INVENTORY.strfn = function(act)
    local target = act.invobject or act.target
    return target and target.MYTH_USE_TYPE or "USE"
end
MYTH_USE_INVENTORY.fn = function(act)
    local obj = act.invobject or act.target
    if obj then
        if obj.components.myth_redlantern_ground then
            return obj.components.myth_redlantern_ground:QuLight(act.doer)
        elseif obj.components.use_gourd  then
            return obj.components.use_gourd:OnUse(act.doer)
        elseif obj.components.myth_use_inventory  then
            return obj.components.myth_use_inventory:OnUse(act.doer)
        end
    end
end
AddAction(MYTH_USE_INVENTORY)

AddComponentAction("INVENTORY", "myth_use_inventory" , function(inst, doer, actions)
    if doer and inst:HasTag("canuseininv_myth") and ( not inst.myth_use_needtag or doer:HasTag(inst.myth_use_needtag)) then
        table.insert(actions, ACTIONS.MYTH_USE_INVENTORY)
    elseif inst.canuseininventory_myth ~= nil and inst.canuseininventory_myth(inst,doer) then
        table.insert(actions, ACTIONS.MYTH_USE_INVENTORY)
    end
end)

AddComponentAction("SCENE", "myth_use_inventory" , function(inst, doer, actions, right)
    if inst:HasTag("canquxialai")  then
        table.insert(actions, ACTIONS.MYTH_USE_INVENTORY)
    elseif right and inst:HasTag("canuseinscene_myth") and ( not inst.myth_use_needtag or doer:HasTag(inst.myth_use_needtag))    then
        table.insert(actions, ACTIONS.MYTH_USE_INVENTORY)
    elseif inst.canuseinscene_myth ~= nil and inst.canuseinscene_myth(inst,doer) then
        table.insert(actions, ACTIONS.MYTH_USE_INVENTORY)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_USE_INVENTORY, 
    function(inst, action)
        local target = action.target or action.invobject
        if target then
            if target.prefab == "myth_redlantern_ground" then --灯笼特殊处理
                return inst.replica.rider ~= nil and inst.replica.rider:IsRiding() and "dolongaction" or "construct"
            --elseif target.prefab == "yama_resurrectionstatue" then
            --    return inst.replica.inventory:EquipHasTag("pennant_commissioner") and "use_pennant_commissioner" or target.onusesgname or "give"
            elseif target.onusesgname ~= nil then
                return target.onusesgname
            end
		end
		return "give"
    end))

AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_USE_INVENTORY,
    function(inst, action)
        local target = action.target or action.invobject
        if target then
            if target.prefab == "myth_redlantern_ground" then --灯笼特殊处理
                return inst.replica.rider ~= nil and inst.replica.rider:IsRiding() and "dolongaction" or "construct"
            elseif target.onusesgname ~= nil then
                return target.onusesgname
            end
		end
		return "give"
    end))

STRINGS.ACTIONS.MYTH_USE_INVENTORY = {
    USE = STRINGS.MYTH_USE_INVENTORY,
    DRINK = STRINGS.USE_GOURD,
    QUDENG = STRINGS.MYTH_RED_TACK,
    MIRROR = STRINGS.USE_MIRROR,
    SKELETON = STRINGS.USE_MYTH_SKELETON,
    COIN = STRINGS.USE_MYTH_COIN,
    ASTRAL = STRINGS.USE_MYTH_ASTRAL,
    PLAYER = STRINGS.USE_MYTH_PLAYER,
}

-------------------------- 贡品 ----------------------------
local RHI_PLACEITEM = Action({mount_valid = true})
RHI_PLACEITEM.id = 'RHI_PLACEITEM'
RHI_PLACEITEM.str = STRINGS.RHI_PLACEITEM
RHI_PLACEITEM.fn = function(act)
    if act.invobject and act.target and act.target.prefab == 'myth_rhino_desk' then
        return act.target:GetItem(act.invobject)
    end
end
AddAction(RHI_PLACEITEM)

AddComponentAction("USEITEM", "myth_rhino_tribute", function(inst, doer, target, actions)
    if target and target.prefab == 'myth_rhino_desk' then
        table.insert(actions, RHI_PLACEITEM)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(RHI_PLACEITEM, "give"))
AddStategraphActionHandler("wilson_client",ActionHandler(RHI_PLACEITEM, "give"))

AddPrefabPostInit("peach", function(inst)
    if TheWorld.ismastersim then
		if not inst.components.myth_rhino_tribute then
			inst:AddComponent('myth_rhino_tribute')
		end
    end
end)
AddComponentPostInit("fuel", function(self) if self.inst then self.inst:AddComponent('myth_rhino_tribute') end end)

local MYTH_RED_GIVE = Action({mount_valid = true,priority = 2})
MYTH_RED_GIVE.id = 'MYTH_RED_GIVE'
MYTH_RED_GIVE.str = STRINGS.MYTH_RED_GIVE
MYTH_RED_GIVE.fn = function(act)
    if act.invobject and act.target and act.target.components.myth_redlantern_ground then
		act.target.components.myth_redlantern_ground:GuaLight(act.invobject)
		return true
    end
end
AddAction(MYTH_RED_GIVE)

AddComponentAction("USEITEM", "myth_redlantern", function(inst, doer, target, actions)
    if target:HasTag("canguashangqu") then
        table.insert(actions, ACTIONS.MYTH_RED_GIVE)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(MYTH_RED_GIVE, "give"))
AddStategraphActionHandler("wilson_client",ActionHandler(MYTH_RED_GIVE, "give"))



local MYTH_YJP_GIVE = Action({mount_valid = true,priority = 2})
MYTH_YJP_GIVE.id = 'MYTH_YJP_GIVE'
MYTH_YJP_GIVE.str = STRINGS.ACTIONS.USEITEM
MYTH_YJP_GIVE.fn = function(act)
    if act.invobject and act.target and act.invobject.components.finiteuses and act.invobject.components.finiteuses.current >= 20 then
            if act.target:HasTag("farm_plant_killjoy") and act.target._base_name ~= nil then
                act.invobject.components.finiteuses:Use(20)
                local x,y,z = act.target.Transform:GetWorldPosition()
                local flower = SpawnPrefab(act.target._base_name.."_oversized")
                if flower then
                    act.target:Remove()
                    flower.Transform:SetPosition(x,y,z)
                end
                return true
            elseif act.target.components.growable ~= nil then
                local stage = act.target.components.growable.stage
                if act.target.components.growable.stages and act.target.components.growable.stages[stage] ~= nil and 
                    act.target.components.growable.stages[stage].name == "rotten" and stage > 1 then
                    act.target.components.growable.stage = stage - 1 
                    act.target.components.growable:StopGrowing()
					local pd = act.target:GetPersistData()
					local new = SpawnPrefab(act.target.prefab)--崩了别怪我 
					if new then
                        new:SetPersistData(pd, {})
                        new.Transform:SetPosition(act.target.Transform:GetWorldPosition())
                        act.target:Remove()
                        act.invobject.components.finiteuses:Use(20)
                         return true
                    end
                end
            end
        --end
    end
end
AddAction(MYTH_YJP_GIVE)

AddComponentAction("USEITEM", "myth_yjp", function(inst, doer, target, actions)
    if target:HasTag("pickable_harvest_str") then -- or target:HasTag("farm_plant") then
        table.insert(actions, ACTIONS.MYTH_YJP_GIVE)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(MYTH_YJP_GIVE, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(MYTH_YJP_GIVE, "dolongaction"))

---给紫金葫芦的特殊关照
AddComponentPostInit("playeractionpicker", function(self)
    local old_get = self.GetInventoryActions
    function self:GetInventoryActions(item, ...)
        local result = old_get(self, item, ...)
        if item and item.prefab == 'purple_gourd' then
            local ret = {}
            for i, v in ipairs(result) do
                if v.action ~= ACTIONS.EQUIP then
                    table.insert(ret, v)
                end
            end
            return ret
        end
        return result
    end
end)

local old = ACTIONS.DISMOUNT.fn
ACTIONS.DISMOUNT.fn = function(act)
    if act.doer == act.target and act.doer.components.rider ~= nil and act.doer.components.rider:IsRiding() then
        local x,y,z = act.doer.Transform:GetWorldPosition()
        if act.doer.components.mk_cloudfxspawner and act.doer.components.mk_cloudfxspawner.canspawn and not TheWorld.Map:IsPassableAtPoint(x, 0, z) then
            act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.RUMMAGE.GENERIC)
            return false
        end
    end
    return  old(act)
end

local old = ACTIONS.INTERACT_WITH.fn
ACTIONS.INTERACT_WITH.fn = function(act)
    if act.doer and act.doer.prefab == "myth_tudi" and act.target ~= nil then
        local x, y, z = act.target.Transform:GetWorldPosition()
        local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(x, 0, z)
        for _, ent in ipairs(ents) do
            if ent.components.farmplanttendable ~= nil then
                if ent ==  act.target and ent.components.farmplanttendable:TendTo(act.doer) then
                    if act.doer.components.talker ~= nil then
                        act.doer.sg:AddStateTag("idle") 
                        act.doer.components.talker:Say(STRINGS.MYTH_TUDI_TIRED[math.random(#STRINGS.MYTH_TUDI_TIRED)])
                        --act.doer.components.talker:Say(GetString(act.doer, "ANNOUNCE_TALK_TO_PLANTS"))
                    end                   
                else
                    ent.components.farmplanttendable:TendTo(act.doer)
                end
            end
        end
        return true
    end
    return old(act)
end

local oldsaddle = ACTIONS.SADDLE.fn
ACTIONS.SADDLE.fn = function(act)
    if act.invobject:HasTag("qingniu_saddle") and not act.target:HasTag("laozi_qingniu") then
        return false
    end
    return oldsaddle(act)
end

STRINGS.ACTIONS.STOPUSINGITEM.LAOZI_BELL = STRINGS.ACTIONS.USEITEM


---种植莲花
local  MYTH_LOTUS_PLANT = Action()
MYTH_LOTUS_PLANT.id = "MYTH_LOTUS_PLANT"
MYTH_LOTUS_PLANT.str = V and "Trồng" or "种植"
MYTH_LOTUS_PLANT.fn = function(act)
    if act.target and act.target.components.myth_lotus_grower and act.target.components.myth_lotus_grower:IsEmpty() then
        return act.target.components.myth_lotus_grower:PlantItem(act.invobject, act.doer)
    end
end

AddAction(MYTH_LOTUS_PLANT)

AddComponentAction("USEITEM", "lotusplant" , function(inst, doer, target, actions, right)
    if target:HasTag("can_plant_lotus") then
        table.insert(actions, ACTIONS.MYTH_LOTUS_PLANT)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_LOTUS_PLANT, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_LOTUS_PLANT, "dolongaction"))


local ponds = {"pond_mos", "pond_cave", "pond"}
for _,v in ipairs(ponds) do
	AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("myth_lotus_grower")
    end)
end

local  MYTH_LOTUS_PICK = Action({distance=2.5})
MYTH_LOTUS_PICK.id = "MYTH_LOTUS_PICK"
MYTH_LOTUS_PICK.str = STRINGS.ACTIONS.PICK
MYTH_LOTUS_PICK.fn = function(act)
    if act.target ~= nil and act.target.components.pickable ~= nil then
        act.target.components.pickable:Pick(act.doer)
        return true
    end
end

AddAction(MYTH_LOTUS_PICK)

AddComponentAction("SCENE", "pickable" , function(inst, doer, actions)
    if inst:HasTag("pickable_lotus") and not (inst:HasTag("fire") or inst:HasTag("intense")) then
        table.insert(actions, ACTIONS.MYTH_LOTUS_PICK)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_LOTUS_PICK, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_LOTUS_PICK, "dolongaction"))

ACTIONS.SHAVE.distance = 2.5

local MYTH_FUCHEN = Action({mount_valid = true,distance=12})
MYTH_FUCHEN.id = 'MYTH_FUCHEN'
MYTH_FUCHEN.strfn = function(act)
    return act.target ~= nil
        and act.target:HasTag("_inventoryitem")
        and "QUWU"
        or "MOREN"
end

MYTH_FUCHEN.fn = function(act)
    if act.invobject and act.invobject.components.fuchen_spell and act.target then
		act.invobject.components.fuchen_spell:CastSpell(act.doer,act.target)
		return true
    end
end
AddAction(MYTH_FUCHEN)

AddComponentAction("EQUIPPED", "fuchen_spell" , function(inst, doer, target, actions, right)
    if right and inst:HasTag("can_spell_fuchen") and target  and target ~= doer
        and ( target:HasTag("_combat") or target:HasTag("_jianzhufanzhuan") or target:HasTag("_inventoryitem")) then
        table.insert(actions, ACTIONS.MYTH_FUCHEN)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(MYTH_FUCHEN,function(inst)
    return "dojostleaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(MYTH_FUCHEN, function(inst)
    return "dojostleaction"
end))

STRINGS.ACTIONS.MYTH_FUCHEN = {
    QUWU = V and "Cách không thu vật" or "隔空取物",
    MOREN = V and "Làm phép" or "施法",
}

---那些建筑可以翻转？
local jianzhus = {
    "myth_redlantern_ground", --灯笼架
    "myth_interiors_ghg_flower", --月宫的花
    "myth_interiors_ghg_he_left", --仙鹤
    "myth_interiors_ghg_he_right",
    "myth_interiors_ghg_groundlight",
}

for _,v in  ipairs(jianzhus) do
	AddPrefabPostInit(v, function(inst) 
        if TheWorld.ismastersim then
            inst:AddComponent("myth_jzfz")
        end
	end)
end



--这里写一种普遍适用的USEITEM类型

local MYTH_USEITEM = Action({priority = 10,mount_valid = true})
MYTH_USEITEM.id = 'MYTH_USEITEM'
MYTH_USEITEM.strfn = function(act)
    local target = act.invobject or act.target
    return target and target.MYTH_USEITEM_TYPE or "USE"
end

MYTH_USEITEM.fn = function(act)
    if act.invobject and act.invobject.components.myth_useitem then
        act.invobject.components.myth_useitem:Use(act.target,act.doer)
        return true
    end
end
AddAction(MYTH_USEITEM)

AddComponentAction("USEITEM", "myth_useitem", function(inst, doer, target, actions)
    if target and inst.myth_useitem_needfn ~= nil and  inst.myth_useitem_needfn(inst,target,doer)  then
        table.insert(actions, MYTH_USEITEM)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(MYTH_USEITEM, function(inst, action)
    local target = action.invobject or action.target
    if target then
        return target.onuseitemsgname or "dolongaction"
	end
	return "dolongaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(MYTH_USEITEM, function(inst, action)
    local target = action.invobject or action.target
    if target then
        return target.onuseitemsgname or "dolongaction"
	end
	return "dolongaction"
end))

STRINGS.ACTIONS.MYTH_USEITEM = {
    USE = STRINGS.MYTH_USE_INVENTORY,
    LAOZIPACK = STRINGS.MYTH_LAOZIPACK,
    GIVE = STRINGS.ACTIONS.GIVE.GENERIC,
}