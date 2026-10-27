


local containers = require "containers"
local params = containers.params

--炼丹炉
params.alchmy_fur =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0), 
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0), 
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = ACTIONS.FUR_COOK.str,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "abc",
}

function params.alchmy_fur.widget.buttoninfo.fn(inst,doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.FUR_COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FUR_COOK.code, inst, ACTIONS.FUR_COOK.mod_name)
    end
end

function params.alchmy_fur.itemtestfn(container, item, slot)
    return item.prefab ~= "mk_jgb" and not item:HasTag("irreplaceable") and item.prefab ~= 'ash' and item.prefab ~= 'purple_gourd'
end

function params.alchmy_fur.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

---pill_bottle_gourd
params.pill_bottle_gourd =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-45, -70, 0),
    },
    type = "gourd",
    openlimit = 1,
}
function params.pill_bottle_gourd.itemtestfn(container, item, slot)
    return item:HasTag("mk_pills")
end

for y = 0, 3 do
    table.insert(params.pill_bottle_gourd.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.pill_bottle_gourd.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

--紫
params.purple_gourd = {
    widget =
    {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-45, -70, 0),
    },
    type = "gourd",
    openlimit = 1,
    itemtestfn = function(inst, item, slot)
        return not item:HasTag("_container") and not item:HasTag("bundle")
    end,
}
for y = 0, 6 do
    table.insert(params.purple_gourd.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(params.purple_gourd.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end
--百宝囊
params.myth_bbn =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
    openlimit = 1,
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.myth_bbn.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end
function params.myth_bbn.itemtestfn(container, item, slot)
    return  not item:HasTag("irreplaceable")
end
--谷仓
params.myth_granary =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_fish_box_3x4",
        animbuild = "ui_myth_granary_4x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = -0.5, 2.5 do
        table.insert(params.myth_granary.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 78, 0))
    end
end

local cooking = require("cooking")

function params.myth_granary.itemtestfn(container, item, slot)
    return  (cooking.ingredients[item.prefab] ~= nil and cooking.ingredients[item.prefab].tags["veggie"] ~= nil or item:HasTag("deployedfarmplant") ) 
	and item:HasTag("cookable")
end

--foodtable
params.myth_food_table =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(275, 0, 0),
        side_align_tip = 100,
    },
    acceptsstacks = false,
    type = "cooker",
}

for y = 0, 3 do
    table.insert(params.myth_food_table.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.myth_food_table.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

function params.myth_food_table.itemtestfn(container, item, slot)
    return item:HasTag("preparedfood") and not container.inst:HasTag("burnt") and not container:Has(item.prefab, 1)
end

--myth_honeypot
params.myth_honeypot =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
    openlimit = 1,
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.myth_honeypot.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

function params.myth_honeypot.itemtestfn(container, item, slot)
    return item.prefab == "honey" or item.prefab == "royal_jelly"
end

params.myth_mooncake_box =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.myth_mooncake_box.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

function params.myth_mooncake_box.itemtestfn(container, item, slot)
	return item:HasTag("myth_mooncake")
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
--紫金葫芦 摇钱树计数器 boss计时
AddPrefabPostInit("world", function(inst)
    inst:AddComponent("gourd_record")
	inst:AddComponent("yqs_record")
    inst:AddComponent("siving_boss_timer")
    inst:AddComponent("myth_rhino_team")
end)