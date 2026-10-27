require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat_loop"),
    ActionHandler(ACTIONS.PICKUP, "eat_enter")
}

local events=
{
	EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
			if inst.prefab=="bat" then
				inst.sg:GoToState("attack", data.target)
			elseif inst.prefab=="bat" then
				if wy_needweapon(inst) then inst:EquipWeapon() end
				inst.sg:GoToState("attackr", data.target)
			elseif inst.prefab=="bat" then
				if wy_needweapon(inst) then inst:EquipWeapon() end
				inst.sg:GoToState("attackr2", data.target)
			end
        end
    end),
	--[[
	EventHandler("gotosleep", function(inst)
		if inst.components.health ~= nil and not inst.components.health:IsDead() then
			inst.sg:GoToState(inst.sg:HasStateTag("sleeping") and "sleeping" or "sleep")
		end
	end),]]
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    --EventHandler("fly_back", function(inst, data)
    --    inst.sg:GoToState("flyback")
    --end),
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
    --CommonHandlers.OnAttacked(),
    --CommonHandlers.OnDeath(),
    CommonHandlers.OnSleep(),
}

local states =
{
	State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
        end,
		
		timeline =
		{
			TimeEvent(8* FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("wiliya_monster/bat/hit2")
				local pos=tw_getforwardpos(inst,2)
				local fx=SpawnPrefab("impact")
				if fx and fx.Transform and pos then
					fx.Transform:SetPosition(pos:Get())
					wy_scale(fx,1)
				end
			end),
			TimeEvent(11*FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap")
			end),
		},
		
		events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},
	
	State{
        name = "attackr",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("fly_away_loop")
        end,
		
		timeline =
		{
			TimeEvent(2* FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("wiliya_monster/bat/atkr")
			end),
			TimeEvent(4*FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap")
			end),
		},
		
		events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},
	
	State{
        name = "attackr2",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("fly_away_loop")
        end,
		
		timeline =
		{
			TimeEvent(2* FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("wiliya_monster/bat/atkr2")
			end),
			TimeEvent(4*FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap")
			end),
		},
		
		events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},
	
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
			local leader=GetClosestInstWithTag("q1bat_leader", inst, 30)
			if leader and wy_isalive(leader) then
				--2个老大聚集,成员小团队融入大团队,如果成员数量相等,谁先idle谁就失去老大资格
				
				if not inst:HasTag("q1bat_leader") then
					--不是老大则加入最近的老大的团队
					inst.wy_leader=leader
					--table.insert(leader.wy_follower,inst.GUID)
					leader.wy_follower[inst.GUID]=true
				else
					--如果自己是老大分2种情况
					if wy_getn(inst.wy_follower) <= wy_getn(leader.wy_follower) then
					
						--自己的团队规模小于等于别人,则纳入别的老大麾下
						for k,v in pairs(inst.wy_follower) do
							--table.insert(leader.wy_follower,v.GUID)
							leader.wy_follower[k]=true
						end
						inst:RemoveTag("q1bat_leader")
						inst.wy_follower={}
						inst.wy_leader=leader
						--table.insert(leader.wy_follower,inst.GUID)
						leader.wy_follower[inst.GUID]=true
					else
						--自己的团队规模大于别人,则让另一个老大纳入自己的旗下
						for k,v in pairs(leader.wy_follower) do
							--table.insert(inst.wy_follower,v.GUID)
							inst.wy_follower[k]=true
						end
						leader:RemoveTag("q1bat_leader")
						leader.wy_follower={}
						leader.wy_leader=inst
						--table.insert(inst.wy_follower,leader.GUID)
						inst.wy_follower[leader.GUID]=true
					end
				end
				
			else	--没有老大则自己争老大
				if not inst:HasTag("q1bat_leader") then
					inst:AddTag("q1bat_leader")
					inst.wy_leader=nil
				end
			end
			
			--头目的标记(有一定威望的头目)
			if wy_getn(inst.wy_follower)>0 then
				--inst.AnimState:SetMultColour(1,1,1,.5)
				--头目标签
				if inst.wy_title==nil then
					inst.wy_title=wy_spawn(inst,"q5word_leader",nil,1)
				end
				--小弟越多头目防御力越高
				inst.components.health.absorb=1-1/wy_getn(inst.wy_follower)
			else
				--inst.AnimState:SetMultColour(1,1,1,1)
				if inst.wy_title~=nil then
					inst.wy_title:Remove()
					inst.wy_title=nil
				end
				inst.components.health.absorb=0
			end
			
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("fly_loop", true)
        end,

        timeline =
        {
		    TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
			--死了就从队伍里除名
			if inst:HasTag("q1bat_leader") then
				inst:RemoveTag("q1bat_leader")
			end
			inst.wy_follower={}
			if inst.wy_leader and type(inst.wy_leader.wy_follower)=="table" then
				inst.wy_leader.wy_follower[inst.GUID]=nil
			end
		
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

    },  
	

    State{
        name = "taunt",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("wiliya_monster/bat/call") end ),
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
            TimeEvent(43*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "eat_enter",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat", false)
        end,

        onexit = function(inst)

        end,

        timeline =
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
            TimeEvent(9*FRAMES, function(inst) inst:PerformBufferedAction()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/bite") end ), 
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{
        name = "eat_loop",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("eat_loop", true)
            inst.sg:SetTimeout(1+math.random()*2)
        end,

        ontimeout= function(inst)
            inst.lastmeal = GetTime()
            inst:PerformBufferedAction()
            inst.sg:GoToState("idle")
        end,

        timeline =
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/chew") end ),
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/chew") end ),
        },

        events =
        {
            EventHandler("attacked", function(inst) inst.components.inventory:DropEverything() inst.sg:GoToState("idle") end) --drop food
        },
    },
}

local walkanims =
{
    startwalk = "fly_loop",
    walk = "fly_loop",
    stopwalk = "fly_loop",
}

CommonStates.AddWalkStates(states,
{
    starttimeline =
    {
        TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
    },

	walktimeline =
    {
        TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
	},

    endtimeline =
    {
        TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
    },

}, walkanims, true)

--
CommonStates.AddSleepStates(states,
{
    starttimeline =
    {
        TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
        TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
    },

    sleeptimeline =
    {
        TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/sleep") end),
    },

    endtimeline =
    {
        TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap") end ),
    },
})


CommonStates.AddFrozenStates(states)


return StateGraph("q1bat", states, events, "idle", actionhandlers)
