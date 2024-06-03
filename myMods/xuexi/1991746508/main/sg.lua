
local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

--喝酒
AddStategraphState('wilson', State{
    name = 'mk_drink',
    tags = {'busy', 'doing', 'nodangle',},
    onenter = function(inst)
        inst.components.locomotor:Stop()
        --音效无
        --inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")   
        inst.components.hunger:Pause()
        inst.AnimState:PlayAnimation("horn")
        inst.AnimState:Show("ARM_normal")
        inst.AnimState:OverrideSymbol("horn01", 'gourd_items', 'swap_wine')
    end,
    timeline={
        TimeEvent(22*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/antivenom_whoosh")  
            inst:PerformBufferedAction() 
        end),  
        TimeEvent(30*FRAMES, function(inst) 
            --inst.sg:RemoveStateTag("busy")
        end),
        
    },     
    events={
        EventHandler("animqueueover", function(inst) 
        	if inst.AnimState:AnimDone() then
        		inst.sg:GoToState("idle") 
        	end
        end),
    },

    onexit = function(inst)    
        inst.components.hunger:Resume()
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
            inst.AnimState:Show("ARM_carry") 
            inst.AnimState:Hide("ARM_normal")
        end
    end,
})

AddStategraphState('wilson_client', State{
    name = 'mk_drink',
    tags = {"doing", "busy", "canrotate"},
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("horn")
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
             end
        end
        inst.sg:SetTimeout(2)
    end,
     
    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
             end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

AddStategraphState("wilson",
	State {
    name = "useyjp",
    tags = { "busy",  'doing', 'nodangle', 'pausepredict'},

    onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("wendy_channel_pst")
        if inst.bufferedaction ~= nil then
            inst.sg.statemem.action = inst.bufferedaction
        end
    end,
	
    timeline =
    {
        TimeEvent(.2, function(inst)
            inst:PerformBufferedAction() 
        end),
    },
    events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

    onexit = function(inst)
        if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
	end,
})

AddStategraphState("wilson_client",
	State {
    name = "useyjp",
    tags = { "busy",  'doing'},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wendy_channel_pst")

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()
            end
            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
})

--芭蕉扇
AddStategraphPostInit("wilson", function(sg)
	local use_fan = sg.states["use_fan"]
	if use_fan then
		local oldonenter = use_fan.onenter
		use_fan.onenter = function(inst,fan)
			if fan ~= nil then
				inst.components.locomotor:Stop()
				inst.sg.statemem.item = invobject
				inst.sg:AddStateTag("busy")
				inst.AnimState:PlayAnimation("action_uniqueitem_pre")
				inst.AnimState:PushAnimation("fan", false)
				inst.AnimState:OverrideSymbol("fan01", fan.prefab, "fan01")
				inst.AnimState:Show("ARM_normal")
				inst.components.inventory:ReturnActiveActionItem(fan)			
			elseif inst.bufferedaction ~= nil and inst.bufferedaction.invobject ~= nil and inst.bufferedaction.invobject.prefab == "bananafan" then
				local invobject = inst.bufferedaction.invobject
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("action_uniqueitem_pre")
				inst.AnimState:PushAnimation("fan", false)
				inst.AnimState:OverrideSymbol("fan01", "bananafan", "fan01")
				inst.AnimState:Show("ARM_normal")
				inst.components.inventory:ReturnActiveActionItem(invobject)
			else
				oldonenter(inst)
			end
		end
	end
end)


local function OnRemoveCleanupTargetFX(inst)
    if inst.sg.statemem.targetfx.KillFX ~= nil then
        inst.sg.statemem.targetfx:RemoveEventCallback("onremove", OnRemoveCleanupTargetFX, inst)
        inst.sg.statemem.targetfx:KillFX()
    else
        inst.sg.statemem.targetfx:Remove()
    end
end

--玩家被吸？

local function tryconsume(self, v, amount)
    if v.components.stackable == nil then
        self:RemoveItem(v):Remove()
        return 1
    elseif v.components.stackable.stacksize > amount then
        v.components.stackable:SetStackSize(v.components.stackable.stacksize - amount)
        return amount
    else
        amount = v.components.stackable.stacksize
        self:RemoveItem(v, true):Remove()
        return amount
    end
    return 0
end

local function Container_ConsumeByTag(self,tag, amount)
    if amount <= 0 then
        return false
    end
    for k, v in pairs(self.slots) do
        if v:HasTag(tag) then
            amount = amount - tryconsume(self, v, amount)
            if amount <= 0 then
                return true
            end
        end
    end
	return false
end

local function ConsumeByTag(self,tag, amount)
    if amount <= 0 then
        return false
    end
    for k = 1, self.maxslots do
        local v = self.itemslots[k]
        if v ~= nil and v:HasTag(tag) then
            amount = amount - tryconsume(self, v, amount)
            if amount <= 0 then
                return true
            end
        end
    end

    if self.activeitem ~= nil and self.activeitem:HasTag(tag) then
        amount = amount - tryconsume(self, self.activeitem, amount)
        if amount <= 0 then
            return true
        end
    end

    local overflow = self:GetOverflowContainer()
    if overflow ~= nil then
		return Container_ConsumeByTag(overflow,tag, amount)
    end
	
	return false 
end
local function OnEat(inst, other)
	if other and other.components.inventory ~= nil then
		local eat = ConsumeByTag(other.components.inventory,"myth_coin", 1)
		if eat and not inst.components.health:IsDead()  then
			inst.components.health:DoDelta(200)
		end
	end
end


local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end
local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

local function armorbrock(inst)
	if inst.components.inventory then
		local inventory = inst.components.inventory
		for k, v in pairs(inventory.equipslots) do
			if v  and v.components.armor then
				v.components.armor:TakeDamage(v.components.armor.maxcondition*1)
			end
		end
	end
end

local function getbank(inst)
	local debugstring = inst.entity:GetDebugString()
	local bank = debugstring:match("bank: (.+) build")
	return bank or ""
end

AddStategraphState("wilson", 
	State{
        name = "myth_knockbacklanded",
        tags = { "knockback", "busy", "nopredict", "nomorph" },

        onenter = function(inst, data)
			if inst._damage_forg_task ~= nil then
				inst._damage_forg_task:Cancel()
			end
			inst.components.combat.externaldamagemultipliers:SetModifier("damage_forg_task", 0.5)
			inst._damage_forg_task = inst:DoTaskInTime(15, function(i) 
				i.components.combat.externaldamagemultipliers:RemoveModifier("damage_forg_task")
				i._damage_forg_task = nil 
			end)
            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)
            inst.components.rider:ActualDismount()
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
			
			local bank = getbank(inst)
			if bank  == "wilson" then
				inst.AnimState:PlayAnimation("hit_spike_heavy")
			end

            if data ~= nil then
                if data.radius ~= nil and data.knocker ~= nil and data.knocker:IsValid() then
                    local x, y, z = data.knocker.Transform:GetWorldPosition()
                    local distsq = inst:GetDistanceSqToPoint(x, y, z)
                    local rangesq = data.radius * data.radius
                    local rot = inst.Transform:GetRotation()
                    local rot1 = distsq > 0 and inst:GetAngleToPoint(x, y, z) or data.knocker.Transform:GetRotation() + 180
                    local drot = math.abs(rot - rot1)
                    while drot > 180 do
                        drot = math.abs(drot - 360)
                    end
                    local k = distsq < rangesq and .3 * distsq / rangesq - 1 or -.7
                    inst.sg.statemem.speed = (data.strengthmult or 1) * 8 * k
                    inst.sg.statemem.dspeed = 0
                    if drot > 90 then
                        inst.sg.statemem.reverse = true
                        inst.Transform:SetRotation(rot1 + 180)
                        inst.Physics:SetMotorVel(-inst.sg.statemem.speed, 0, 0)
                    else
                        inst.Transform:SetRotation(rot1)
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end

            inst.sg:SetTimeout(11 * FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.speed ~= nil then
                inst.sg.statemem.speed = inst.sg.statemem.speed + inst.sg.statemem.dspeed
                if inst.sg.statemem.speed < 0 then
                    inst.sg.statemem.dspeed = inst.sg.statemem.dspeed + .075
                    inst.Physics:SetMotorVel(inst.sg.statemem.reverse and -inst.sg.statemem.speed or inst.sg.statemem.speed, 0, 0)
                else
                    inst.sg.statemem.speed = nil
                    inst.sg.statemem.dspeed = nil
                    inst.Physics:Stop()
                end
            end
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
        },

        ontimeout = function(inst)
			armorbrock(inst)
			if inst.components.pinnable and inst.components.pinnable.canbepinned then
				inst.components.pinnable:Stick()
			else
				inst.sg:GoToState("idle")
			end
        end,

        onexit = function(inst)
            if inst.sg.statemem.speed ~= nil then
                inst.Physics:Stop()
            end
        end,
	}
)

AddStategraphState("wilson", 
	State{
        name = "eatbyfrog",
        tags = { "notalking", "busy", "nopredict", "silentmorph","noattack" },

        onenter = function(inst, attacker)
			local fx = SpawnPrefab("collapse_small")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			if attacker then
				inst.Transform:SetPosition(attacker.Transform:GetWorldPosition())
				inst.eat_boss = attacker
			end
            inst:Hide()	
			inst.Physics:SetActive(false)
            inst.sg.statemem.eatenbyfrog = true
			inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/roll_VO", "eatttttt")
			
            inst.DynamicShadow:Enable(false)
			if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			
			if inst.components.inventory then
				inst.components.inventory:Hide()
			end
			inst.components.health:SetInvincible(true)
			
			inst.sg.statemem.eatgold = inst:DoPeriodicTask(0.5, function()
				if attacker and attacker:IsValid() then
					inst.Transform:SetPosition(attacker.Transform:GetWorldPosition())
					OnEat(attacker, inst)
				end
			end)
            inst.sg:SetTimeout(12)
        end,

        ontimeout = function(inst)
			inst.Physics:SetActive(true) --开启物理
			inst.sg.statemem.eatenbyfrog = nil
			TemporarilyRemovePhysics(inst, 0.2) --修改物理
			local knocker = inst
			if inst.eat_boss ~= nil then
				knocker = inst.eat_boss
			end
			inst.sg:GoToState("myth_knockbacklanded", {knocker = knocker, radius = 5,strengthmult = 3})
        end,
        events =
        {
            EventHandler("spitbyfrog", function(inst)
				inst.Physics:SetActive(true) --开启物理
				inst.sg.statemem.eatenbyfrog = nil
				TemporarilyRemovePhysics(inst, 0.2) --修改物理
				local knocker = inst
				if inst.eat_boss ~= nil then
					knocker = inst.eat_boss
				end
				inst.sg:GoToState("myth_knockbacklanded", {knocker = knocker, radius = 5,strengthmult = 3})
            end),
            EventHandler("onremove", function(inst)
				if inst.eat_boss ~= nil then
					inst.eat_boss.eat_player = nil
					inst.eat_boss:OnSpit()
				end
            end),
        },
        onexit = function(inst)
			inst.eat_boss = nil
			inst:Show()
			inst.DynamicShadow:Enable(true)
			inst.SoundEmitter:KillSound("eatttttt")
			if inst.sg.statemem.eatgold ~= nil then
                inst.sg.statemem.eatgold:Cancel()
                inst.sg.statemem.eatgold = nil
            end
            if inst.sg.statemem.eatenbyfrog then
				inst.Physics:SetActive(true)
                inst.sg.statemem.eatenbyfrog = nil
            end
			inst.components.health:SetInvincible(false)
			
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
			if inst.components.inventory then
				inst.components.inventory:Show()
			end
        end,
    }
)


AddStategraphState("wilson",
State{
    name = "use_laozi_bell",
    tags = { "doing", "playing" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("cowbell", false)
        inst.AnimState:OverrideSymbol("cbell", "laozi_bell", "cbell")
        inst.AnimState:Show("ARM_normal")

        local invitem = (inst.bufferedaction ~= nil and inst.bufferedaction.invobject) or nil
        inst.components.inventory:ReturnActiveActionItem(invitem)
    end,

    timeline =
    {
        TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),

        TimeEvent(15 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end),

        TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(56*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),
        TimeEvent(67*FRAMES, function(inst) inst.SoundEmitter:PlaySound("yotb_2021/common/cow_bell") end),

        
    },

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end
    end,
}
)
local function bell(sg)
    local old_use = sg.actionhandlers[ACTIONS.STOPUSINGITEM].deststate
    sg.actionhandlers[ACTIONS.STOPUSINGITEM].deststate = function(inst, action)
        if action.invobject ~= nil and action.invobject:HasTag("laozi_bell") then
			return "use_laozi_bell"
		end
		return old_use(inst, action)
    end
end
AddStategraphPostInit("wilson", bell)

--武器右键技能动作修改
local function NewAoeSg(sg)
    local old_castaoe = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
        if action.invobject ~= nil and action.invobject.myth_aoespellsg ~= nil  then
            return action.invobject:myth_aoespellsg(inst, action)
            --if action.invobject:HasTag("weapon_gtt")  then
            --    return "weapon_gtt_start"
            --elseif action.invobject:HasTag("weapon_syf")  then
            --    return "weapon_syf"
            --elseif action.invobject:HasTag("weapon_syd")  then
            --    return "weapon_syd"
            --end
        end
        return old_castaoe(inst, action)
    end
end
AddStategraphPostInit("wilson", NewAoeSg)
AddStategraphPostInit("wilson_client", NewAoeSg)

--扢挞藤SG
AddStategraphState('wilson',
    State{
        name = "weapon_gtt_start",
        tags = { "aoe", "doing", "busy", "nointerrupt", "nomorph","myth_nostunned" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.sg:SetTimeout(1.2)
			inst.AnimState:PlayAnimation("atk_leap_pre")
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                if buffaction.pos ~= nil then
                    inst:ForceFacePoint(buffaction:GetActionPoint():Get())
                end
            end
        end,
        timeline =
        {
            --TimeEvent(1, function(inst)
            --    inst:PerformBufferedAction()
            --    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            --end),
        },
        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
        events =
        {
            EventHandler("weapon_gtt_do", function(inst, data)
                inst.sg.statemem.supergtt = true
                inst.sg:GoToState("weapon_gtt", {
                    data = data,
                })
            end),
            EventHandler("animover", function(inst, data)
                if inst.AnimState:AnimDone() then
                    if inst.AnimState:IsCurrentAnimation("atk_leap_pre") then
                        inst.AnimState:PlayAnimation("atk_leap_lag")
                        inst:PerformBufferedAction()
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },
    }
)

AddStategraphState('wilson_client',
    State
    {
        name = "weapon_gtt_start",
        tags = { "doing", "busy", "nointerrupt"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk_leap_pre")
            inst.AnimState:PlayAnimation("atk_leap_lag", false)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    }
)

AddStategraphState('wilson',
    State{
        name = "weapon_gtt",
        tags = { "aoe", "doing", "busy", "nointerrupt", "nopredict", "nomorph","myth_nostunned" },

        onenter = function(inst, data)
            if data then
                data = data.data
                if data ~= nil and
                    data.targetpos ~= nil then
                    ToggleOffPhysics(inst)
                    inst.Transform:SetEightFaced()
                    inst.AnimState:PlayAnimation("atk_leap")
                    inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
                    inst.sg.statemem.startingpos = inst:GetPosition()
                    inst.sg.statemem.weapon = data.weapon
                    inst.sg.statemem.targetpos = data.targetpos
                    inst.sg.statemem.flash = 0
                    if inst.sg.statemem.startingpos.x ~= data.targetpos.x or inst.sg.statemem.startingpos.z ~= data.targetpos.z then
                     inst:ForceFacePoint(data.targetpos:Get())
                        inst.Physics:SetMotorVel(math.sqrt(distsq(inst.sg.statemem.startingpos.x, inst.sg.statemem.startingpos.z, data.targetpos.x, data.targetpos.z)) / (12 * FRAMES), 0 ,0)
                    end
                return
                end
            end
            inst.sg:GoToState("idle", true)
        end,
        onupdate = function(inst)
            if inst.sg.statemem.flash > 0 then
                inst.sg.statemem.flash = math.max(0, inst.sg.statemem.flash - .1)
                local c = math.min(1, inst.sg.statemem.flash)
                inst.components.colouradder:PushColour("leap", c, c, 0, 0)
            end
        end,
        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .1, .1, 0, 0)
            end),
            TimeEvent(11 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .2, .2, 0, 0)
            end),
            TimeEvent(12 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .4, .4, 0, 0)
                ToggleOnPhysics(inst)
                inst.Physics:Stop()
                inst.Physics:SetMotorVel(0, 0, 0)
                inst.Physics:Teleport(inst.sg.statemem.targetpos.x, 0, inst.sg.statemem.targetpos.z)
            end),
            TimeEvent(13 * FRAMES, function(inst)
                ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .015, .8, inst, 20)
                inst.components.bloomer:PushBloom("leap", "shaders/anim.ksh", -2)
                inst.components.colouradder:PushColour("leap", 1, 1, 0, 0)
                inst.sg.statemem.flash = 1.3
                inst.sg:RemoveStateTag("nointerrupt")
                if inst.sg.statemem.weapon:IsValid() then --伤害！
                    inst.sg.statemem.weapon:DoLeap(inst, inst.sg.statemem.startingpos, inst.sg.statemem.targetpos)
                end
            end),
            TimeEvent(25 * FRAMES, function(inst)
                inst.components.bloomer:PopBloom("leap")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
                inst.Physics:Stop()
                inst.Physics:SetMotorVel(0, 0, 0)
                local x, y, z = inst.Transform:GetWorldPosition()
                if TheWorld.Map:IsPassableAtPoint(x, 0, z) and not TheWorld.Map:IsGroundTargetBlocked(Vector3(x, 0, z)) then
                    inst.Physics:Teleport(x, 0, z)
                else
                    inst.Physics:Teleport(inst.sg.statemem.targetpos.x, 0, inst.sg.statemem.targetpos.z)
                end
            end
            inst.Transform:SetFourFaced()
            inst.components.bloomer:PopBloom("leap")
            inst.components.colouradder:PopColour("leap")
        end,
    }
)

--霜钺斧SG
AddStategraphState("wilson", State {
    name = "weapon_syf",
    tags = { "aoe", "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("chop_loop")
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
    end,
    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/common/twirl", nil, nil, true)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            inst:PerformBufferedAction()
        end),
    },
    events = {
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end),
    }
})

AddStategraphState("wilson_client", State {
    name = "weapon_syf",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("chop_loop")
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()
            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
        inst.sg:SetTimeout(2)
    end,
    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
        end),
    },
    onupdate = function(inst)
        if inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

--syd  weapon_syd
AddStategraphState("wilson", State {
    name = "weapon_syd",
    tags = { "aoe", "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_leap")
        inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
    end,
    timeline =
    {
        TimeEvent(16 * FRAMES, function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/common/twirl", nil, nil, true)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            inst:PerformBufferedAction()
        end),
    },
    events = {
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end),
    }
})
AddStategraphState("wilson_client", State {
    name = "weapon_syd",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_leap")
        inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()
            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
        inst.sg:SetTimeout(2)
    end,
    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
        end),
    },
    onupdate = function(inst)
        if inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})



local special_weapon = {
    myth_weapon_gtt = true,
    whip_commissioner = true,

}
local function EventPostInit(self)
    local old_fn = self.actionhandlers[ACTIONS.ATTACK].deststate
    self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
        
        local isdead = inst.replica.health and inst.replica.health:IsDead()
        local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local target = action.target
        local _combat = inst.components.combat or inst.replica.combat
        local isriding = inst.replica.rider:IsRiding()
        if isdead or isriding or not(item and target and item:IsValid() and target:IsValid() and _combat) then
            return old_fn(inst, action)
        end
        if special_weapon[item.prefab]  then
            inst.sg.mem.localchainattack = not action.forced or nil
            return   "myth_weapon_attack" 
        end
        return old_fn(inst, action)
    end
end
AddStategraphPostInit('wilson', EventPostInit)
AddStategraphPostInit('wilson_client', EventPostInit)


AddStategraphState('wilson', State{
    name = "myth_weapon_attack",

    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end

        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
        inst.sg.statemem.whiptime = 1
        if equip ~= nil and equip:HasTag("whip") then --鞭子的武器
            
            local hat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if hat ~= nil and hat.components.container ~= nil and hat:HasTag("soullostbox") then
                local has , num = hat.components.container:Has("soul_ghast", 13)
                if has then
                    inst.sg.statemem.quickwhip = true
                    inst.sg.statemem.whiptime = 1.25
                    inst.AnimState:SetDeltaTimeMultiplier(inst.sg.statemem.whiptime)
                end
            end
            inst.AnimState:PlayAnimation("whip_pre")
            inst.AnimState:PushAnimation("whip", false)
            inst.sg.statemem.iswhip = true
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
            --inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
            cooldown = math.max(cooldown, 17 * FRAMES/inst.sg.statemem.whiptime)
        elseif equip ~= nil and equip:HasTag("weapon_gtt") then
            inst.AnimState:PlayAnimation("atk_prop_pre")
            inst.AnimState:PushAnimation('atk_prop', false)
            inst.sg.statemem.isgtt = true
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            cooldown = math.max(cooldown, 13 * FRAMES)
        end
        inst.sg:SetTimeout(cooldown)

        if target ~= nil then
            inst.components.combat:BattleCry()
            if target:IsValid() then
                inst:FacePoint(target:GetPosition())
                inst.sg.statemem.attacktarget = target
            end
        end
    end,

    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= FRAMES then
                if inst.sg.statemem.projectilesound ~= nil then
                    inst.SoundEmitter:PlaySound(inst.sg.statemem.projectilesound, nil, nil, true)
                    inst.sg.statemem.projectilesound = nil
                end
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end
    end,
    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst)
            if inst.sg.statemem.isgtt then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            elseif  inst.sg.statemem.quickwhip then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
            end
        end),

        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.quickwhip then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")          
            elseif inst.sg.statemem.iswhip then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
            end
        end),

        TimeEvent(10 * FRAMES, function(inst)
            if (inst.sg.statemem.iswhip and not inst.sg.statemem.quickwhip) or inst.sg.statemem.isbook or inst.sg.statemem.ispocketwatch  then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
})

AddStategraphState('wilson_client', State{
    name = "myth_weapon_attack",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)

        local buffaction = inst:GetBufferedAction()
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local cooldown = 0
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
            cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        inst.components.locomotor:Stop()
        inst.sg.statemem.whiptime = 1
        if equip ~= nil and equip:HasTag("whip") then

            local hat = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if hat ~= nil and hat.replica.container ~= nil and hat:HasTag("soullostbox") then
                local has , num = hat.replica.container:Has("soul_ghast", 13)
                if has then
                    inst.sg.statemem.quickwhip = true
                    inst.sg.statemem.whiptime = 1.25
                    inst.AnimState:SetDeltaTimeMultiplier(inst.sg.statemem.whiptime)
                end
            end

            inst.AnimState:PlayAnimation("whip_pre")
            inst.AnimState:PushAnimation("whip", false)
            inst.sg.statemem.iswhip = true
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain", nil, nil, true)
            if cooldown > 0 then
                cooldown = math.max(cooldown, 17 * FRAMES/inst.sg.statemem.whiptime)
            end
        elseif equip ~= nil and equip:HasTag("weapon_gtt") then
            inst.AnimState:PlayAnimation("atk_prop_pre")
            inst.AnimState:PushAnimation('atk_prop', false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
            inst.sg.statemem.isgtt = true
            cooldown = math.max(cooldown, 13 * FRAMES)
        end

        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
            end
        end

        if cooldown > 0 then
            inst.sg:SetTimeout(cooldown)
        end
    end,

    timeline =
    {

        TimeEvent(6 * FRAMES, function(inst)
            if inst.sg.statemem.isgtt then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            elseif  inst.sg.statemem.quickwhip then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
            end
        end),

        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.quickwhip then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")          
            elseif inst.sg.statemem.iswhip then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
            end
        end),


        TimeEvent(10 * FRAMES, function(inst)
            if (inst.sg.statemem.iswhip and not inst.sg.statemem.quickwhip) or inst.sg.statemem.isbook or inst.sg.statemem.ispocketwatch then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,
    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
})