
local states =
{
    State{
        name = "idle",
        tags = { "idle" },

        onenter = function(inst)
			local idle = math.random()< 0.4 and "idle" or "idle_blink"
            inst.AnimState:PlayAnimation(idle, true)
        end,
    },
	
    State{
        name = "refuse",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("refuse")
            if not inst.talkrcd  then
                inst.SoundEmitter:PlaySound("bianzhong/sfx/talk_LP")
                inst.talkrcd = true
                inst:DoTaskInTime(5.5,function(...)
                    inst.talkrcd = false
                end)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
    State{
        name = "talk",

        onenter = function(inst,anim)
			local anim = anim or "talk"
            inst.AnimState:PlayAnimation(anim)
            if not inst.talkrcd  then
                inst.SoundEmitter:PlaySound("bianzhong/sfx/talk_LP")
                inst.talkrcd = true
                inst:DoTaskInTime(5.5,function(...)
                    inst.talkrcd = false
                end)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    State{
        name = "spell",

        onenter = function(inst,anim)
            inst.AnimState:PlayAnimation("spell")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
}

return StateGraph("myth_chang_e", states, {}, "idle")
