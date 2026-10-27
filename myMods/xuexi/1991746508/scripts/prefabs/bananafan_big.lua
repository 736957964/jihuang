local assets =
{
    Asset("ANIM", "anim/bananafan_big.zip"),
    Asset("ANIM", "anim/swap_bananafan_big.zip"),
    Asset("ANIM", "anim/tornado.zip"),
    Asset("ANIM", "anim/tornado_stick.zip"),
	Asset("ATLAS", "images/inventoryimages/bananafan_big.xml")
}

local prefabs =
{
	"banana_tornado",
}
local WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
local TARGET_TAGS = { "_combat" }
for k, v in pairs(WORK_ACTIONS) do
    table.insert(TARGET_TAGS, k.."_workable")
end
local TARGET_IGNORE_TAGS = { "INLIMBO" }

local function destroystuff(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 3, nil, TARGET_IGNORE_TAGS, TARGET_TAGS)
    for i, v in ipairs(ents) do
        --stuff might become invalid as we work or damage during iteration
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() and
                (TheNet:GetPVPEnabled() or not (inst.WINDSTAFF_CASTER_ISPLAYER and v:HasTag("player"))) then
               
			   local damage = 1 --伤害是1
			   local creatures = {}
                v.components.combat:GetAttacked(inst, damage, nil, "wind")
                
				if v:IsValid() and	inst.WINDSTAFF_CASTER ~= nil and inst.WINDSTAFF_CASTER:IsValid() and
					not (v.components.health ~= nil and v.components.health:IsDead()) then
                    if v.components.combat ~= nil and
						not (v.components.follower ~= nil and
							v.components.follower.keepleaderonattacked and
							v.components.follower:GetLeader() == inst.WINDSTAFF_CASTER) then
						v.components.combat:SuggestTarget(inst.WINDSTAFF_CASTER)
					end
					if v.components.locomotor ~= nil then
						local debuffkey = inst.prefab
						if v._banana_speedmulttask ~= nil then
							v._banana_speedmulttask:Cancel()
						end
						v._banana_speedmulttask = v:DoTaskInTime(3, function(i) 
                            if i.components.locomotor then
                                i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) 
                                i._banana_speedmulttask = nil 
                            end
                        end)

						v.components.locomotor:SetExternalSpeedMultiplier(v, debuffkey, 0)
					end	
                end
            elseif v.components.workable ~= nil and
                v.components.workable:CanBeWorked() and
                v.components.workable:GetWorkAction() and
                WORK_ACTIONS[v.components.workable:GetWorkAction().id] then
                SpawnPrefab("collapse_small").Transform:SetPosition(v.Transform:GetWorldPosition())
                v.components.workable:WorkedBy(inst, 1)
            end
        end
    end
end

local function OnUse(inst, target)

	if  not TheWorld.state.israining then 
		TheWorld:PushEvent("ms_forceprecipitation", true)
	end   
	local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 32, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, {"myth_rhino_fx","smolder", "fire", "player","alchmy_fur","freezable" })
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
		if TheWorld.state.iswinter and target ~= v and v.components.freezable ~= nil then
			v.components.freezable:AddColdness(1)
			v.components.freezable:SpawnShatterFX()		
		end
    end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function spawntornado(staff, target, pos)
	if staff.components.rechargeable and staff.components.rechargeable.recharging then
		return false
	end	
    local owner = staff.components.inventoryitem.owner
	if not owner or not (owner.components.sanity and owner.components.sanity.current >= 5 ) or not
		 (owner.components.hunger and owner.components.hunger.current >= 5 ) then
		return false
	end
	owner.components.sanity:DoDelta(-5)
	owner.components.hunger:DoDelta(-5)
	
    local tornado = SpawnPrefab("banana_tornado")
    tornado.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(staff, target))
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end
	staff.rechargerate = 3
	staff.components.rechargeable:StartRecharging()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_bananafan_big", "swap_fan")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onuse(inst)
	local owner = inst.components.inventoryitem.owner
	if owner and owner.components.hunger then
		if owner.components.hunger.current < 15 then
			owner.components.talker:Say("饥饿值不足")		
			return false
		end
		if	owner.sg then
			owner.sg:GoToState("use_fan",inst)
		end
		OnUse(inst, owner)
		owner.components.hunger:DoDelta(-15)
		if  owner.components.inventory and owner.components.inventory:Has("dust_resistant_pill", 1) then
			local pill = owner.components.inventory:FindItem(function(item) return item.prefab == "dust_resistant_pill" end)
			if pill and pill.components.fueled then
				pill.components.fueled:DoDelta(-480)
			end
            return false
		else
			inst.rechargerate = 1
			inst.components.rechargeable:StartRecharging()
            return true
		end
	end
end

local function rechargingratefn(inst)
	local owner = inst.components.inventoryitem.owner
	local a = 1/inst.rechargerate
	if inst.rechargerate == 3 and owner and  owner.components.inventory and owner.components.inventory:Has("dust_resistant_pill", 1) then
		return a/2
	end
	return a
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bananafan_big")
    inst.AnimState:SetBuild("bananafan_big")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fan")
	
    inst:AddTag("nopunch")
	inst:AddTag("rechargeable")

    inst:AddTag("quickcast")

    inst.spelltype = "BANANAFAN"
	
	local swap_data = {sym_build = "swap_bananafan_big",sym_name = "swap_fan"}

	MakeInventoryFloatable(inst, "large", 0.05, {0.6, 0.35, 0.6}, true, -27, swap_data)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.rechargerate = 1

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bananafan_big.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster:SetSpellFn(spawntornado)
    inst.components.spellcaster.castingstate = "castspell_tornado"

	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(onuse)
	
	inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
	inst.components.rechargeable:SetRechargeTime(15)
	local old_StartRecharging = inst.components.rechargeable.StartRecharging
	inst.components.rechargeable.StartRecharging = function(self)
		old_StartRecharging(self)
		if self.inst.components.useableitem ~= nil then
			self.inst.components.useableitem.inuse = true
		end
	end
	local old_StopRecharging = inst.components.rechargeable.StopRecharging
	inst.components.rechargeable.StopRecharging = function(self)
		old_StopRecharging(self)
		if self.inst.components.useableitem ~= nil then
			self.inst.components.useableitem.inuse = false
		end
	end
	inst.components.rechargeable.rechargingrate = rechargingratefn 
	inst:RegisterComponentActions("rechargeable")
	
    MakeHauntableLaunch(inst)

    return inst
end

local brain = require("brains/tornadobrain")

local function ontornadolifetime(inst)
    inst.task = nil
    inst.sg:GoToState("despawn")
end

local function SetDuration(inst, duration)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
end

local function tornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("tornado")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SG_banana_tornado")
    inst:SetBrain(brain)

    inst.WINDSTAFF_CASTER = nil
	inst.jifei = {}
    inst.persists = false

    inst.SetDuration = SetDuration
    inst:SetDuration(5)

	inst:DoPeriodicTask(0.5, destroystuff)

    return inst
end

return Prefab("bananafan_big", fn, assets),
	Prefab("banana_tornado", tornado_fn, assets)
