local assets =
{
    Asset("ANIM", "anim/krampus_basic.zip"),
    Asset("ANIM", "anim/krampus_build.zip"),
    Asset("SOUND", "sound/krampus.fsb"),
}

local prefabs =
{
    "charcoal",
    "monstermeat",
    "krampus_sack",
}

local brain = require "brains/krampusbrain"                 ----c_give("krampus")

SetSharedLootTable( 'krampus',
{
    {'monstermeat',  1.0},
    {'charcoal',     1.0},
    {'charcoal',     1.0},
   --- {'krampus_sack',  .02},
})

local function NotifyBrainOfTarget(inst, target)
    if inst.brain and inst.brain.SetTarget then
        inst.brain:SetTarget(target)
    end
end

local function makebagfull(inst)
    inst.AnimState:Show("SACK")
    inst.AnimState:Hide("ARM")
end

local function makebagempty(inst)
    inst.AnimState:Hide("SACK")
    inst.AnimState:Show("ARM")
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    --inst.components.combat:ShareTarget(data.attacker, SEE_DIST, function(dude) return dude:HasTag("hound") and not dude.components.health:IsDead() end, 5)
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function ReleasePlayer(inst)
	--[[
	for k,v in pairs(inst.zg_pickedman) do 
		if v and v:HasTag("player") then
			v:PushEvent("zg_buff_bepicked_remove")
		end
	end]]
	if type(inst.children)=="table" then
		for k,v in pairs(inst.children) do
			if v and k and k:HasTag("player") then
				k:PushEvent("zg_buff_bepicked_remove")
			end
		end
	end
end

local function Retarget(inst)
	local invader = nil
    invader = FindEntity(inst, 60, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	
	if TheWorld.state.isday then
		invader=nil
	else
		----	敌视语句
		if invader then
			local sayrandom = math.random()
			if sayrandom < .05 then
				inst.components.talker:Say("别解释了!快上车!")
			elseif sayrandom < .1 then
				inst.components.talker:Say("给你看一样东西!")
			elseif sayrandom < .15 then
				inst.components.talker:Say("等等!我最近发现了新宝贝")
			end
		end
	end
	
    return invader
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeCharacterPhysics(inst, 1000, .5)

    inst.DynamicShadow:SetSize(3, 1)
    inst.Transform:SetFourFaced()
	
	--
	inst:AddTag("zg_marine")
	inst:AddTag("zg_cr1")

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
	inst:AddTag("shadowboss")

    inst.AnimState:Hide("ARM")
    inst.AnimState:SetBank("krampus")
    inst.AnimState:SetBuild("krampus_build")
    inst.AnimState:PlayAnimation("run_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	--inst.zg_pickedman={}
	inst:AddComponent("talker")

    inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 8
    inst:SetStateGraph("SGzg_krampus")

    inst:SetBrain(brain)

    MakeLargeBurnableCharacter(inst, "krampus_torso")
    MakeLargeFreezableCharacter(inst, "krampus_torso")

 --[[   inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!--]]

    inst:AddComponent("sleeper")
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(900)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "krampus_torso"
    inst.components.combat:SetDefaultDamage(75)
    inst.components.combat:SetAttackPeriod(1.5)
	inst.components.combat:SetRetargetFunction(1, Retarget)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('krampus')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
	--inst:ListenForEvent("death", ReleasePlayer)
	--inst:ListenForEvent("onremove", ReleasePlayer)
    --MakeHauntablePanic(inst)

    return inst
end

return Prefab("krampus", fn, assets, prefabs)
