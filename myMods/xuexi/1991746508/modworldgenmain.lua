GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
require("map/tasks")
require("map/lockandkey")

local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

--[[更新部分
local retrofiting = require("map/retrofit_savedata")

local old_DoRetrofitting = retrofiting.DoRetrofitting

retrofiting.DoRetrofitting = function(savedata, world_map, ...)
	old_DoRetrofitting(savedata, world_map, ...)
	local dirty = false
	local entities = savedata.ents
	local isnotinmap = true
	for prefab, ents in pairs(entities) do
    if prefab == "myth_rhino_desk_spawner" then
			isnotinmap = false
			break
    end
  end
	if isnotinmap then
		  require("map/myth_rhino_desk_retrofitting").TurnOfTidesRetrofitting(TheWorld.Map, savedata)
		  dirty = true
	end
	if dirty then
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
	end
end
--========]]

Layouts["广寒宫"] = StaticLayout.Get("map/static_layouts/layout_ghg", 
  {
        start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        layout_position = LAYOUT_POSITION.CENTER,
		disable_transform = true,
    }
)
Layouts["桃园"] = StaticLayout.Get("map/static_layouts/layout_peach",
	{
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
	disable_transform = true,
})

--29号地皮被我征用了
GROUND.MYTH_ZHULIN = 29

Layouts["熊猫林"] = StaticLayout.Get("map/static_layouts/layout_xml",{
            start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
           fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
            layout_position = LAYOUT_POSITION.CENTER,
            disable_transform = true,
})
Layouts["熊猫林"].ground_types = {GROUND.IMPASSABLE,GROUND.ROCKY,GROUND.ROAD,GROUND.MYTH_ZHULIN}

AddLevelPreInitAny(function(level)
	if level.location == "forest" then
		if level.ocean_prefill_setpieces ~= nil then
			level.ocean_prefill_setpieces["广寒宫"]  = 1
			level.ocean_prefill_setpieces["桃园"]  = 1
			level.ocean_prefill_setpieces["熊猫林"]  = 1
		end
	end
end)