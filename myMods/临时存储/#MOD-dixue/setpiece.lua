--[[	Copyright (c) 2015 Kzisor/Ysovuka	]]
local require = GLOBAL.require

require "util"

-- Layout type used to determine how we will add the layout to the map.
local LAYOUT_TYPE =
{
	RANDOM = 0,
	GROUND = 1,
	ROOM = 2,
}

-- The Layouts table is where we will add our set piece layout.
local Layouts = require("map/layouts").Layouts

--[[
	This function acts as a wrapper which we will use to create our layout.
	-----------------------------------------------------------------------
--]]
local ParseNestedKey -- must define it first so we can recurse
ParseNestedKey = function(obj, key, value)
    if #key == 1 then
        obj[key[1]] = value
        return
    else
        local key_head = key[1]
        if key_head == nil then
            return
        end
         
        local key_tail = {}
        for i,k in ipairs(key) do
            if i > 1 then table.insert(key_tail, k) end
        end
        if obj[key_head] == nil then
            obj[key_head] = {}
        end
        ParseNestedKey(obj[key_head], key_tail, value)
    end
end
require("constants")
local default_tiles = {}

for k, v in pairs(GLOBAL.GROUND)do
   table.insert(default_tiles, v)
end
 
local function LoadLayout( src, additionalProps )
 
    -- Load layout into a variable.
    local staticlayout = require( src )
 
    -- Table which contains the tiles for the layout.
    -- Required to be nil for a check later on in the code.
    local tiles = nil
 
    -- Get tiles from imported layout.
    if staticlayout.tilesets ~= nil then
 
        -- Iterate through the tilesets to obtain all the tiles used.
        -- Note: There should ever only be one tile set being used, a custom or the default.
        for _, tileset in pairs( staticlayout.tilesets ) do
 
            -- Make sure the tiles are not nil.
            if tileset.tiles ~= nil then
 
                -- Iterate through the tiles of the tileset.
                for _, tile in ipairs( tileset.tiles ) do
 
                    -- Make sure the properties table is not nil.
                    if tile.properties ~= nil then
 
                        -- Get property for tile from 3 available options.
                        local tile_name = tile.properties["name"] or tile.properties["id"] or tile.properties["tile_name"] or nil
 
                        if tile_name ~= nil then
 
                            -- Required for a check later on in the code.
                            if tiles == nil then
                                 
                                tiles = { }
 
                            end
 
                            -- Insert it into the tiles table for the layout.
                            table.insert( tiles, GROUND[ string.upper( tile_name ) ] )
 
                        end
 
                    end
 
                end
 
            end
 
        end
 
    end
     
    -- Allows us to support 16 and 64 wide grids from tiled.
    local tilefactor = math.ceil(64/staticlayout.tilewidth)
 
    -- Base layout creation.
    local layout = additionalProps or {}
     
    -- Type of layout we are loading.
    layout.type = GLOBAL.LAYOUT.STATIC
 
    -- Scale of the layout.
    layout.scale = 1
 
    -- See ..\Don't Starve Mod Tools\tiles\dont_starve\tiles.png for default tiles.
    layout.ground_types = nil
    layout.ground = {}
 
    -- Uses custom tiles from layout file if found. Otherwise we use default selection.
    if tiles ~= nil then
 
        layout.ground_types = tiles
 
    else
 
        layout.ground_types = default_tiles
 
    end
 
    -- See \tools\tiled\dont_starve\objecttypes.xml for objects
    layout.layout = {}
 
    for _, layer in ipairs( staticlayout.layers ) do
 
        -- The background tile layer must be named BG_TILES.
        if layer.type == "tilelayer" and layer.name == "BG_TILES" then
 
            -- This has not been refactored from the original as this seems to be the only way to accomplish this task.
            local val_per_row = layer.width * (tilefactor-1)
            local i = val_per_row
 
            while i < #layer.data do       
                local data = {}    
                local j = 1
                while j < layer.width and i+j < #layer.data do
                    table.insert(data, layer.data[i+j])
                    j = j + tilefactor
                end
                table.insert(layout.ground, data)    
                i = i + val_per_row + layer.width
            end
 
        -- The forground objects must be named FG_OBJECTS
        elseif layer.type == "objectgroup" and layer.name == "FG_OBJECTS" then
 
            local x_eq = 64.0 - ( staticlayout.width / tilefactor ) / 2
            local y_eq = 64.0 - ( staticlayout.height / tilefactor ) / 2
 
            -- Iterate through the objects list.
            for _, obj in ipairs( layer.objects ) do
 
                if layout.layout[ obj.type ] == nil then
 
                    layout.layout[ obj.type ] = { }
 
                end
 
                -- TODO: Check the object properties for other options to substitute here.
                local x = obj.x + obj.width / 2
                x = x / x_eq
 
                local y = obj.y + obj.height / 2
                y = y / y_eq
 
                local width = obj.width / 64.0
                local height = obj.height / 64.0
 
                local properties = {}
 
                if obj.properties then
 
                    for k, v in pairs( obj.properties ) do
 
                        local key = k:split(".")
 
                        local number_v = GLOBAL.tonumber( v )
 
                        if v == "true" or v == "false" then
 
                            ParseNestedKey( properties, key, v == "true" )
 
                        else
 
                            ParseNestedKey( properties, key, number_v or v )
 
                        end
 
                    end
 
                end
 
                table.insert( layout.layout[ obj.type ], { x = x, y = y, properties = properties, width = width, height = height } )
 
            end
 
            if layout.initfn then
 
                 
                layout.initfn( layout.layout )
 
            end
 
        end
 
    end
 
    return layout
 
end

local function AddLayout( name, layout )

    if layout == nil then
	    -- Puts our layout in the Layouts table.
	    Layouts[name] = LoadLayout("map/static_layouts/"..name)
	else
	    -- Puts our layout in the Layouts table.
	   Layouts[name] = layout	   
	end

	-- We return the name and the layout for later usage.
	return name, Layouts[name]
end

-- Thie LEVELTYPE table is used to indicate the level identification.
require("map/level")
local LEVELTYPE = GLOBAL.LEVELTYPE
LEVELTYPE.ALL = "ALL"

local function GetAreas( ground, task_list, areas )

	-- Initialize the task list.
	local tasks = require("map/tasks")

	-- Localize the function so it operates faster.
	local GetTaskByName = tasks.GetTaskByName

	-- Localize the list so it operates faster.
	local tasks = tasks.sampletasks

	-- Ensure that we have a list to iterate through.
	if task_list ~= nil then
		
		-- Assign a value to the areas variable if it's not already supplied.
		areas = areas or { }

		-- Iterate through the task_list.
		for i, task_name in pairs(task_list) do

			-- Get the task by it's name.
			local task = GetTaskByName(task_name, tasks)

			-- Ensure that the ground is the proper ground to spawn in.
			if task ~= nil and (ground == "Any" or ground == task.room_bg) then

				-- Add the task to the return list.
				table.insert(areas, task_name)

			end

		end

		-- If we did not find any areas to spawn, return nil.
		if #areas == 0 then
		
			return nil
		
		end

		-- Return the list of areas we found.
		return areas

	end

	-- No list to iterate through, so we cannot find any areas so return our previous list or nil.
	return areas or nil

end

local function GetAmount( count, chance )

	-- Set chance to chance or 100 to ensure it spawns.
	chance = chance or 100

	-- Set count to count or 1 to ensure it spawns.
	count = count or 1

	-- Localized return variable.
	local _count = 0

	-- Iterate through the amount of potential spawns.
    for i = 0, count do

    	-- Ensure that we are lucky enough to spawn.
        if (chance * 10) >= math.random(1, 1000) then

        	-- Increase spawn count.
            
            _count = _count + 1
        
        end

    end

    -- Return the amount which will spawn.
    return _count

end

local function AddGround( level, layout_name, count, chance, ground )

	-- Ensure that we have a variable to store our data.
	if level.set_pieces == nil then
		level.set_pieces = {}
	end

	-- Obtain the list of area's it can spawn from in tasks.
	local areas = GetAreas( ground, level.tasks )

	-- Obtain the list of area's it can spawn from in optional tasks.
	areas = GetAreas( ground, level.optionaltasks, areas )

	-- Ensure we have a proper area to spawn before we add it to the list.
	if areas ~= nil then

		-- Get the proper count to add.
		count = GetAmount( count, chance )

		-- Ensure that we have at least one that can spawn.
		if count >= 1 then

			-- Add our layout to the level set pieces so it can spawn in the tasks.
			level.set_pieces[layout_name] = { count = count, tasks = areas }

		end

	end

end

local function AddRandom( level, layout_name )

	-- Ensure that we have a variable to store our data.
    if not level.random_set_pieces then
        level.random_set_pieces = {}
    end
 
 	-- Add our layout to the random set pieces layout.
    table.insert(level.random_set_pieces, layout_name)

end

local function AddRoom( room, layout_name, count, chance )

	-- Ensure that we have a variable to store our data.
    if not room.contents.countstaticlayouts then
        room.contents.countstaticlayouts = {}
    end
 
 	count = GetAmount( count, chance )

 	if count >= 1 then

 		-- Add our layout to the room layouts.
        room.contents.countstaticlayouts[layout_name] = count

    end

end

--[[
	This function acts as a wrapper which we will use to modify the amount of random set pieces which will spawn.
	------------------------------------------------------------------------------------------------------------
	level_id		-	Level Identification (LEVELTYPE.ALL, LEVELTYPE.SURVIVAL, LEVELTYPE.CAVE, LEVELTYPE.ADVENTURE
						LEVELTYPE.TEST, LEVELTYPE.UNKNOWN, LEVELTYPE.CUSTOM)
	count 			-	The amount of random set pieces which will spawn.
--]]
local function SetRandomAmount( level_id, amount )

	if level_id == LEVELTYPE.ALL then

		AddLevelPreInitAny( function( level )

			level.numrandom_set_pieces = amount

		end)

	else

		AddLevelPreInit( level_id, function( level )

			level.numrandom_set_pieces = amount

		end)

    end
end


--[[
	This function acts as a wrapper which we will use to add our custom layout as a set piece.
	------------------------------------------------------------------------------------------------------------
	level_id		-	Level Identification (LEVELTYPE.ALL, LEVELTYPE.SURVIVAL, LEVELTYPE.CAVE, LEVELTYPE.ADVENTURE, 
						LEVELTYPE.TEST, LEVELTYPE.UNKNOWN, LEVELTYPE.CUSTOM)
	layout_name 	-	The name of the layout which we will be adding, if the layout has not already been added we will add the layout.
	layout_type			-	Layout Type (LAYOUT_TYPE.RANDOM, LAYOUT_TYPE.GROUND, LAYOUT_TYPE.ROOM) Default is LAYOUT_TYPE.RANDOM.
	count			-	The amount of set pieces we want to spawn. Default is 1.
	chance			-	The percentage change the layout will spawn. Default is 100.
	terrain			-	Identification of the ground or room. Identification must coincide with the type or it will error out.
						Ground Example: GROUND.GRASS or GROUND.DIRT
						Room Example: Badlands or BGGrass
--]]
local function CreateSetPiece( level_id, layout_name, layout_type, count, chance, terrain )

	-- Ensure that our layout has been created, otherwise create it.
	if Layouts[layout_name] == nil then
		
		AddLayout( layout_name )		

	end

	if layout_type == LAYOUT_TYPE.ROOM then
		-- Layout is a room layout.

		AddRoomPreInit( terrain, function( room )

			AddRoom( room, layout_name, count, chance )

		end)

	elseif layout_type == LAYOUT_TYPE.GROUND then
		-- Layout is a ground layout.

		-- Determine level_id so we can push the proper function.
		if level_id == LEVELTYPE.ALL then

			AddLevelPreInitAny( function( level )

				AddGround( level, layout_name, count, chance, terrain )

			end)

		else

			AddLevelPreInit( level_id, function( level )

				AddGround( level, layout_name, count, chance, terrain )

			end)

		end


	else
		-- Layout either is nil or is random.

		-- Determine level_id so we can push the proper function.
		if level_id == LEVELTYPE.ALL then

			AddLevelPreInitAny( function( level )

				AddRandom( level, layout_name )

			end)

		else

			AddLevelPreInit( level_id, function( level )

				AddRandom( level, layout_name )

			end)

		end

	end

end

env.Map.CreateLayout = AddLayout
env.Map.CreateSetPiece = CreateSetPiece
env.Map.LAYOUT_TYPE = LAYOUT_TYPE
env.Map.LEVELTYPE = LEVELTYPE