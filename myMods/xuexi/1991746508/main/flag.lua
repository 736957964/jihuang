
AddPrefabFiles("mk_battle_flag")

-----flag
local writeables = require "writeables"
local SignGenerator = require "signgenerator"
local old_makescreen  = writeables.makescreen
local kinds = {}
kinds["mk_battle_flag"] = {
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
            widget:OverrideText( SignGenerator(inst, doer) )
        end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
	
}
writeables.makescreen = function(inst, doer)
    local data = kinds[inst.prefab]
    if doer and doer.HUD  and inst.prefab == "mk_battle_flag" then
        return doer.HUD:ShowWriteableWidget(inst, data)
    end
	old_makescreen(inst, doer)
end

local OldPick = ACTIONS.PICKUP.fn
ACTIONS.PICKUP.fn = function(act)
    if act.doer.components.inventory ~= nil and act.target ~= nil and act.target.components.flagpickupable ~= nil and not act.target:IsInLimbo() then
        act.doer:PushEvent("onpickupitem", {item = act.target})
        return act.target.components.flagpickupable:OnPickup(act.doer)
    end
    return OldPick(act)
end

AddComponentAction("SCENE", "flagpickupable" , function(inst, doer, actions, right)
	if right then
		table.insert(actions, GLOBAL.ACTIONS.PICKUP)
	end
end)
