
AddPrefabFiles("laozi", "laozi_sp")

AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("laozitimer")
end)
AddPrefabPostInit("cave", function(inst)
    inst:AddComponent("laozitimer")
end)

--加组件强行可交易(我裂开了)
local items = {
    "shroom_skin",
    "bearger_fur",
    "dragon_scales",
    "deerclops_eyeball",
    "ruins_bat",
    "amulet",
    "blueamulet",
    "purpleamulet",
    "featherfan",
    "hivehat",
    "armorruins",
    "nightmarefuel",
    
    "raincoat",
    "sweatervest",
    "trunkvest_summe",
    "trunkvest_winter",
    "reflectivevest",
    "hawaiianshirt",
    "beargervest",
    
    "armor_bramble",
    "armordragonfly",
    "armorgrass",
    "armormarble",
    "armorskeleton",
    "armor_sanity",
    "armorsnurtleshell",
    "armorslurper",
    "armorwood",
	"malbatross_beak",
}

ACTIONS.FAN.priority=-1
for k, v in pairs(items) do
    AddPrefabPostInit(v, function(inst)
        if TheWorld.ismastersim then
            if not inst.components.tradable then
                inst:AddComponent("tradable")
            end
        end 
    end)
end