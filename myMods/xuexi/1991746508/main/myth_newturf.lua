

local GroundTiles = require("worldtiledefs")

local GROUND_OCEAN_COLOR =
{ 
    primary_color =         {  0,   0,   0,  25 }, 
    secondary_color =       { 0,  20,  33,  0 }, 
    secondary_color_dusk =  { 0,  20,  33,  80 }, 
    minimap_color =         {  23,  51,  62, 102 },
}

--放到地皮里面
table.insert(GroundTiles.ground, {GROUND.MYTH_ZHULIN, 
{ 	name = "jungle",      
	noise_texture = "levels/textures/Ground_noise_savannah_detail.tex",               
	runsound="dontstarve/movement/run_dirt",        
	walksound="dontstarve/movement/walk_dirt",      
	snowsound="dontstarve/movement/run_ice",    
	mudsound = "dontstarve/movement/run_mud", 
	flashpoint_modifier = 0, 
	colors= GROUND_OCEAN_COLOR,
}
})

--可以铲起来 得到的产物
GroundTiles.turf[GROUND.MYTH_ZHULIN] = { name = "myth_zhu",   anim = "turf_myth_zhu"  ,   bank_build = "myth_turfs" }

--桃园地皮可制作
GroundTiles.turf[GROUND.QUAGMIRE_PARKFIELD] = { name = "quagmire_parkfield",   anim = "turf_quagmire_parkfield"  ,   bank_build = "myth_turfs" }

--小地图的部分
local MINIMAP_GROUND_PROPERTIES =
{
	{ GROUND.MYTH_ZHULIN,  { name = "map_edge",      noise_texture = "levels/textures/mini_savannah_noise.tex" } },
}

--命名部分
GROUND_NAMES[GROUND.MYTH_ZHULIN ] = "Myth Zhu"

--=================资源加载部分==============================GroundTiles.assets
local function AddImage( name )
    table.insert( Assets, Asset( "IMAGE", "levels/textures/"..name..".tex" ) )
end

local function AddTileImage( name )
    table.insert( Assets, Asset( "IMAGE", "levels/tiles/"..name..".tex" ) )
    table.insert( Assets, Asset( "FILE", "levels/tiles/"..name..".xml") )
end
AddImage("Ground_noise_savannah_detail")
AddImage("mini_savannah_noise")

AddTileImage("jungle")

table.insert( Assets, Asset("ANIM", "anim/myth_turfs.zip"))
table.insert( Assets, Asset("ATLAS", "images/inventoryimages/turf_myth_zhu.xml"))
table.insert( Assets, Asset("ATLAS", "images/inventoryimages/turf_quagmire_parkfield.xml"))
--=================资源加载部分==============================

--minimap
AddPrefabPostInit("minimap", function(inst)
    for i, data in pairs( MINIMAP_GROUND_PROPERTIES ) do
        local tile_type, layer_properties = unpack( data )
        inst.MiniMap:AddRenderLayer(
            MapLayerManager:CreateRenderLayer(
                tile_type,
                resolvefilepath(GroundAtlas( layer_properties.name )),
                resolvefilepath(GroundImage( layer_properties.name )),
                resolvefilepath(layer_properties.noise_texture)
            )
        )
    end
end)

--修改地皮的物品栏图标
local turf_images = { "turf_myth_zhu", "turf_quagmire_parkfield"}
for i, v in ipairs(turf_images) do
    AddPrefabPostInit( v,function(inst)
        if inst.components.inventoryitem then
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..v..".xml"
            inst.components.inventoryitem.imagename = v
        end
    end)
end
