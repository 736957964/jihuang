table.insert(PrefabFiles, "myth_flyer_fx")

local IsFlying = function(inst) return inst and inst.components.mk_flyer and inst.components.mk_flyer:IsFlying()end
local IsInRoom = function(inst) local pos = inst and inst:GetPosition() return pos and math.abs(pos.z) > 1200 end

local MKFLYLAND = Action({ priority=3,--[[instant =true]]})
MKFLYLAND.id = "MKFLYLAND"
MKFLYLAND.str = STRINGS.MKFLYLAND
MKFLYLAND.fn = function(act)
    if act.doer and act.doer.components.mk_flyer  then
		act.doer.components.mk_flyer:SetFlying(false)
		return true
	end
	return false
end
AddAction(MKFLYLAND)
AddStategraphActionHandler("wilson",ActionHandler(MKFLYLAND, "myth_flyskill_down"))
AddStategraphActionHandler("wilson_client",ActionHandler(MKFLYLAND, "myth_flyskill_down"))

local flyercollect = function(inst, doer, actions, right)
    if (inst == doer) and IsFlying(doer) and not inst:HasTag("playerghost") then
		table.insert(actions, ACTIONS.MKFLYLAND)
    end   
end
AddComponentAction("SCENE", "mk_flyer" ,flyercollect , modname) 

local oldPlayFootstep=GLOBAL.PlayFootstep
GLOBAL.PlayFootstep=function(inst, ...) --去除脚步声
	if inst and IsFlying(inst) then
		return
	end
	return oldPlayFootstep(inst, ...)
end

local function StopFlying(inst, noAnim) --服务器
	if inst and IsFlying(inst) then
		inst.components.mk_flyer:SetFlying(false)
		inst.components.mk_flyer._percent:set(0)
	end
end

AddClassPostConstruct( "components/builder_replica", function(self, inst)
	local old_MakeRecipeAtPoint = self.MakeRecipeAtPoint
	function self:MakeRecipeAtPoint(...)
		if IsFlying(self.inst) and self.inst.prefab ~= "yama_commissioners" then
			return false
		end
		return old_MakeRecipeAtPoint(self,...)
	end
end)

AddComponentPostInit("locomotor",function(self)
	self.mythVar_height_override = 0

	local oldRunForward=self.RunForward
	function self:RunForward(direct, ...)
		oldRunForward(self, direct, ...)
		if self.mythVar_height_override ~= 0 then
			local a,b,c = self.inst.Physics:GetMotorVel()
			local y = self.inst:GetPosition().y
			local h = self.inst.components.mk_flyer and self.inst.components.mk_flyer:GetFlyTargetHeight()
			if y and h then
				self.inst.Physics:SetMotorVel(a, (h-y)*32, c)
			end
		end
	end
	local oldGetRunSpeed = self.GetRunSpeed
	function self:GetRunSpeed(...)
		if self.inst.components.mk_flyer ~= nil and self.inst.components.mk_flyer:IsFlying() then
			return self.inst.components.mk_flyer.runspeed
		elseif self.inst._is_player_astral ~= nil and self.inst._is_player_astral:value() then
			return self.runspeed + 2
		end
		return oldGetRunSpeed(self,...)
	end	
end)

AddComponentPostInit("freezable",function(self)
	local oldFreeze=self.Freeze
	self.Freeze=function(self, freezetime, ...)
		StopFlying(self.inst, true) --冰冻结束飞行
		return oldFreeze(self, freezetime, ...)
	end
end)

AddComponentPostInit("grogginess",function(self)
	local oldKnockOut=self.KnockOut
	self.KnockOut=function(self, ...)
		StopFlying(self.inst, true) --睡眠结束飞行
		return oldKnockOut(self, ...)
	end
end)

AddComponentPostInit("highlight",function(self)
	local oldHighlight=self.Highlight
	self.Highlight=function(self, r, g, b, ...)
		if self.inst:HasTag("NOHIGHLIGHT") then --禁止高亮
			return
		end
		return oldHighlight(self, r, g, b, ...)
	end
end)

AddPrefabPostInit("lureplant", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(0.1,function()
		local pt = Point(inst.Transform:GetWorldPosition())
		if inst.Physics then
			inst.Physics:Teleport(pt.x,0,pt.z)
		end	
	end)
end)

AddPrefabPostInit("explosivehit", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(1, inst.Remove)
end)

AddPrefabPostInit("rock_ice", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(0.1,function()
		local pt = Point(inst.Transform:GetWorldPosition())
		if inst.Physics then
			inst.Physics:Teleport(pt.x,0,pt.z)
		end	
	end)
end)

local function checkfly(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 15, {"player"}, {"INLIMBO","playerghost"})
    for i, v in ipairs(ents) do
        if v:IsValid() and v.components.health and not v.components.health:IsDead() and IsFlying(v) then	
			if v.components.mk_flyer:GetPercent() >= 1 then
				StopFlying(v)
				v.components.combat:GetAttacked(inst, 20, nil, "darkness")
				v.components.sanity:DoDelta(-10)	
			end
		end
	end
end

AddPrefabPostInit("stalker", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoPeriodicTask(1, checkfly, 1)
end)

STRINGS.ACTIONS.CASTSPELL.BANANAFAN = "风卷残云"

local flyrecipe = {
	myth_flyskill = true,
	myth_flyskill_mk = true,
	myth_flyskill_nz = true,
	myth_flyskill_wb = true,
	myth_flyskill_pg = true,
	myth_flyskill_yj = true,
	myth_flyskill_yt = true,
}


local function AddPlayerSgPostInit(fn)
    AddStategraphPostInit('wilson', fn)
    AddStategraphPostInit('wilson_client', fn)
end

AddPlayerSgPostInit(function(self)
	-- 修改走路动画
	local run = self.states.run 
	if run then
		local old_enter = run.onenter
		function run.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if IsFlying(inst) then
				if not inst.AnimState:IsCurrentAnimation("myth_surf_loop") then
					inst.AnimState:PlayAnimation("myth_surf_loop", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + 0.01)
			end
		end
	end

	local run_start = self.states.run_start 
	if run_start then
		local old_enter = run_start.onenter
		function run_start.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if IsFlying(inst) then
				inst.AnimState:PlayAnimation("myth_surf_pre")
			end
		end
	end

	local run_stop = self.states.run_stop 
	if run_stop then
		local old_enter = run_stop.onenter
		function run_stop.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if IsFlying(inst) then
				inst.AnimState:PlayAnimation("myth_surf_pst")
			end
		end
	end

	-- 修改配方触发state
	local old_handler = self.actionhandlers[ACTIONS.BUILD].deststate
    self.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action)
        if not inst.sg:HasStateTag('busy')
        	and inst.components.mk_flyer
            and action.recipe and action.recipe:find("myth_flyskill")then
            if IsInRoom(inst) then
            	inst:ClearBufferedAction()
            	if inst.components.talker then
            		inst.components.talker:Say(STRINGS.MYTHNOFLYINROOM)
				end
				return "idle"
			elseif inst._is_player_astral ~= nil and inst._is_player_astral:value() then
				return "idle"
			elseif IsFlying(inst) then
				return nil
			else
				return 'myth_flyskill_up'
			end
        else
            return old_handler(inst, action)
        end
    end
end)

local function JumpState(client, is_up)
	-- timeline
	local tl = client and {
		TimeEvent(0* FRAMES, function(inst)inst:PerformPreviewBufferedAction() end),
    	TimeEvent(4* FRAMES, function(inst)inst.sg:RemoveStateTag('busy') end),
	}or {
		TimeEvent(1* FRAMES, function(inst)inst:PerformBufferedAction() end)
	}
	-- onupdate
	local up = client and function(inst)
		if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle", true)
        end
    end or function() end
    -- events
    local evt = {
    	EventHandler(client and "animqueueover" or "animover", function(inst) inst.sg:GoToState("idle") end)
    }

	return State{
		name = "myth_flyskill".. (is_up and "_up" or "_down"),
	    tags ={"idle", "myth_flyskill","busy","doing","notalking"},
	    onenter = function(inst)
	
	        inst.components.locomotor:Stop()
			if  inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
				inst.sg:GoToState("idle")
				inst:ClearBufferedAction()
				return 
			end
	        inst.AnimState:HideSymbol("droplet")
	        inst.AnimState:PlayAnimation("jumpboat")
	        inst.components.mk_flyer._percent:set_local(is_up and 0 or 1)

	        if inst.components.health then
				inst.components.health:SetInvincible(true)
			end

			inst.sg:SetTimeout(2)
	    end,

	    timeline = tl,

	    onupdate = function(inst, dt)
	    	-- up(inst, dt)
	    	if is_up then
	    		inst.components.mk_flyer._percent:set_local(math.min(inst.components.mk_flyer:GetPercent() + 1.4*dt, 1))
	    	else
	    		inst.components.mk_flyer._percent:set_local(math.max(inst.components.mk_flyer:GetPercent() - 2*dt, 0))
	    	end
	    	-- print(inst.components.mk_flyer.percent)
	    end,

	    ontimeout = function(inst)
	    	inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("idle")
            inst.sg:GoToState("idle", true)
        end,

	    events = evt,

	    onexit = function(inst)
	    	-- print("exit state!")
			if not inst.components.mk_flyer:IsFlying() then --避免起飞过程下来触发bug
				inst.components.mk_flyer._percent:set(0)
			else
				inst.components.mk_flyer._percent:set(is_up and 1 or 0)
			end
	    	if inst.components.health then
				inst.components.health:SetInvincible(false)
			end
		end,
	}
end

AddStategraphState("wilson", JumpState(false, true))
AddStategraphState("wilson_client", JumpState(true, true))
AddStategraphState("wilson", JumpState(false, false))
AddStategraphState("wilson_client", JumpState(true, false))

------------------------------------改写SG-------------------------------------


local mythcharacters ={
	monkey_king = true,
	neza = true,
	white_bone = true,
	pigsy = true,
	yangjian = true,
	myth_yutu = true,
	yama_commissioners = true,
}

local function PostInit(self)
	local old_can = self.CanBuild
	function self:CanBuild(recname, ...)
		if recname == 'myth_flyskill' and ( self.inst._is_flypill ~= nil and self.inst._is_flypill:value())  then
            return old_can(self,'myth_flyskill_sanity', ...)
    	end
		return old_can(self, recname, ...)
    end
    local old_build = self.DoBuild
    if not old_build then
    	return
    end

    function self:DoBuild(recname, ...)
		if recname == 'myth_flyskill' and ( self.inst._is_flypill ~= nil and self.inst._is_flypill:value())  then
            return old_build(self,'myth_flyskill_sanity', ...)
    	end
		return old_build(self, recname, ...)
    end
end

AddComponentPostInit('builder', PostInit)
AddClassPostConstruct('components/builder_replica', PostInit)

AddClassPostConstruct("widgets/recipepopup",function(self)
	local old_set = self.SetRecipe
	function self:SetRecipe(rec, owner)
		if rec and rec.name == "myth_flyskill" and owner then --是我的配方
			if owner._is_flypill ~= nil and owner._is_flypill:value() then
				rec.ingredients = {Ingredient(CHARACTER_INGREDIENT.SANITY, 25)} --临时修改一下
			else
				rec.ingredients = {Ingredient("fly_pill", 1,"images/monkey_king_item.xml")}
			end
		end
		return old_set(self,rec, owner)
	end
end)

AddPlayerPostInit(function(inst)

	if not mythcharacters[inst.prefab] then
		inst:AddTag("myth_flyskill")
	end
	inst.AnimState:HideSymbol("droplet")

	inst._is_flypill = net_bool(inst.GUID, "myth.flypill", "flypilldirty")

	inst:AddComponent("mk_flyer")
	if TheWorld.ismastersim then
		inst:ListenForEvent("hungerdelta", function(inst,data) --饱食度耗尽结束飞行
			if data and data.newpercent<=0 then
				StopFlying(inst)
			end
		end)
		inst:ListenForEvent("death", function(inst,data) --死亡结束飞行
			StopFlying(inst)
		end)
		inst:ListenForEvent("transform_wereplayer", function(inst,data) --死亡结束飞行
			StopFlying(inst)
		end)
		inst:AddComponent("myth_playernwd")

		inst:AddComponent("mk_cloudfxspawner")
		inst.components.mk_cloudfxspawner.qn = true
		inst.components.mk_cloudfxspawner.first = false
		inst.components.mk_cloudfxspawner.canspawn = false
	end

end)
