local _G = GLOBAL
local FRAMES = _G.FRAMES
local EQUIPSLOTS = _G.EQUIPSLOTS
local EventHandler = _G.EventHandler
local GetWorld = _G.GetWorld
local SpawnPrefab = _G.SpawnPrefab
local State = _G.State
local DEGREES = _G.DEGREES
local Vector3 = _G.Vector3
local STRINGS = _G.STRINGS
local ACTIONS = _G.ACTIONS
local FOODTYPE = _G.FOODTYPE

local TUNING = _G.TUNING
local PLAYERSTUNLOCK = _G.PLAYERSTUNLOCK
local GetTime = _G.GetTime
local HUMAN_MEAT_ENABLED = _G.HUMAN_MEAT_ENABLED


----	击倒
AddStategraphEvent("wilson", 
	EventHandler("zg_buff_knockout", function(inst)
		if _G.wy_isalive(inst) then
			inst.sg:GoToState("zg_buff_knockout")
		end
	end)	
)
----	被包裹起来
AddStategraphEvent("wilson", 
	EventHandler("zg_buff_bepicked", function(inst,data)
		local attacker=data.attacker
		if _G.wy_isalive(inst) and attacker --and type(attacker.zg_pickedman)=="table" 
			then
			inst.sg:GoToState("zg_buff_bepicked",attacker)
		end
	end)	
)

AddStategraphState("wilson", 
	State
	{
		name = "zg_buff_knockout",
		tags = { "busy", "pausepredict" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("wakeup")
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:RemotePausePrediction()
			end
			inst.sg:SetTimeout(8 * FRAMES + inst.AnimState:GetCurrentAnimationLength())
		end,
		
		timeline=
		{	
			
		},
		
		events=
		{
			
		},	
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle", true)
		end,	
	}
)

local function release(inst)
	inst.sg:GoToState("zg_buff_knockout")
	--inst:PushEvent("zg_buff_knockout")
end

AddStategraphState("wilson", 
	State{
        name = "zg_buff_bepicked",
        tags = { "notalking", "busy", "nopredict", "silentmorph","noattack","zg_bepicked" },

        onenter = function(inst, attacker)
			GLOBAL.TheNet:Announce( inst:GetDisplayName().." 被 "..GLOBAL.STRINGS.NAMES[string.upper(attacker.prefab)].." 装到了袋子里" )
			
			local time=10
			if attacker.components.combat then
				attacker.components.combat:SetTarget(nil)
			end
			inst.zg_pickedmaster=attacker
			
            inst:Hide()
            inst.DynamicShadow:Enable(false)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(GLOBAL.COLLISION.WORLD)
		
            inst.sg.statemem.isplayerhidden = true
			if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			if inst.components.inventory then
				inst.components.inventory:Hide()
			end
			inst.sg.statemem.task2 = inst:DoPeriodicTask(1*FRAMES, function()
				if attacker and _G.wy_isalive(attacker) then
					inst.Transform:SetPosition( attacker:GetPosition():Get() )
					
					inst.components.hunger:DoDelta(-5/30, true, true)
					inst.components.sanity:DoDelta(-5/30, true)
					inst.components.health:DoDelta(-5/30, true, attacker.prefab, true)
					
				else
					inst:PushEvent("zg_buff_bepicked_remove")
				end
			end)
            inst.sg:SetTimeout(time)
        end,

        ontimeout = function(inst)
            return release(inst)
        end,

        events =
        {
            EventHandler("zg_buff_bepicked_remove", function(inst)
				return release(inst)
            end),
        },

        onexit = function(inst)
		
			if inst.zg_pickedmaster and inst.zg_pickedmaster.components.combat then
				inst.zg_pickedmaster.components.combat:SetTarget(inst)
				inst.zg_pickedmaster=nil
			end
		
			local x,y,z = inst.Transform:GetWorldPosition()
			GLOBAL.ChangeToCharacterPhysics(inst)
			inst.Transform:SetPosition(x,0,z)
			
			if inst.sg.statemem.task2 ~= nil then
                inst.sg.statemem.task2:Cancel()
                inst.sg.statemem.task2 = nil
            end
            if inst.sg.statemem.isplayerhidden then
                inst:Show()
                inst.DynamicShadow:Enable(true)
                inst.sg.statemem.isplayerhidden = nil
            end
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
			if inst.components.inventory then
				inst.components.inventory:Show()
			end
        end,
    }
)






