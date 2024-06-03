--[[    Copyright © 2015 Ysovuka/Kzisor  ]]

return {

    -- A
    
    
    -- B
    beefalo_farm =
    {
        count = configurations.set_piece.beefalo_farm.count,
        chance = configurations.set_piece.beefalo_farm.chance,
        enabled = configurations.set_piece.beefalo_farm.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "beefalo_farm", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.SAVANNA )
        end,
    },
    
    -- C
    calamity_camp =
    {
        count = configurations.set_piece.calamity_camp.count,
        chance = configurations.set_piece.calamity_camp.chance,
        enabled = configurations.set_piece.calamity_camp.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "calamity_camp", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    colourful_mushroom_farm =
    {
        count = configurations.set_piece.colourful_mushroom_farm.count,
        chance = configurations.set_piece.colourful_mushroom_farm.chance,
        enabled = configurations.set_piece.colourful_mushroom_farm.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "colourful_mushroom_farm", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    conquering_pigs =
    {
        count = configurations.set_piece.conquering_pigs.count,
        chance = configurations.set_piece.conquering_pigs.chance,
        enabled = configurations.set_piece.conquering_pigs.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "conquering_pigs", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
        
    -- D
    
    -- E
    example =
    {
        count = configurations.set_piece.example.count,
        chance = configurations.set_piece.example.chance,
        enabled = configurations.set_piece.example.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "example", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.MARSH )
        end,
    },
    -- F
    fairy_rings =
    {
        enabled = configurations.set_piece.fairy_rings.enabled,
        load = function(count, chance)
        
            local FairyRingSizes =
            {
                Small = 7,
                Medium = 10,
                Large = 15,
                Huge = 20,
                Gigantic = 25,
            }
            
            local FairyRingLayout =
            {
                type = LAYOUT.CIRCLE_EDGE,
	            start_mask = PLACE_MASK.NORMAL,
	            fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	            layout_position = LAYOUT_POSITION.CENTER,
	            defs = 
	            {
	 	            unknown_plant = { "flower", "flower_evil" },
	            },
	            count = 
	            {
		            unknown_plant = 0,
	            },
	            scale = 1.5
            }
            
            for k, v in pairs(FairyRingSizes) do
            
                local layout = FairyRingLayout
                layout.count.unknown_plant = v
                
                Map.CreateLayout( "FairyRing"..k, layout )
                Map.CreateSetPiece( Map.LEVELTYPE.ALL, "FairyRing"..k, Map.LAYOUT_TYPE.RANDOM )
            
            end
            
        end,
    },
    -- G
    
    -- H
    healthy_resources =
    {
        count = configurations.set_piece.healthy_resources.count,
        chance = configurations.set_piece.healthy_resources.chance,
        enabled = configurations.set_piece.healthy_resources.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "healthy_resources", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    hound_rocks =
    {
        count = configurations.set_piece.hound_rocks.count,
        chance = configurations.set_piece.hound_rocks.chance,
        enabled = configurations.set_piece.hound_rocks.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "hound_rocks", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.DIRT )
        end,
    },
    
    -- I
    insane_flint =
    {
        count = configurations.set_piece.insane_flint.count,
        chance = configurations.set_piece.insane_flint.chance,
        enabled = configurations.set_piece.insane_flint.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "insane_flint", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.MARSH )
        end,
    },
    
    -- J
    
    -- K
    koalefant_farm =
    {
        count = configurations.set_piece.koalefant_farm.count,
        chance = configurations.set_piece.koalefant_farm.chance,
        enabled = configurations.set_piece.koalefant_farm.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "koalefant_farm", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.SAVANNA )
        end,
    },
    
    -- L
    
    -- M
    mactusk_city =
    {
        count = configurations.set_piece.mactusk_city.count,
        chance = configurations.set_piece.mactusk_city.chance,
        enabled = configurations.set_piece.mactusk_city.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "MacTuskCity", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.DIRT )
        end,
    },
    
    mactusk_town =
    {
        count = configurations.set_piece.mactusk_town.count,
        chance = configurations.set_piece.mactusk_town.chance,
        enabled = configurations.set_piece.mactusk_town.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "MacTuskTown", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    maxwell_merm_shrine =
    {
        count = configurations.set_piece.maxwell_merm_shrine.count,
        chance = configurations.set_piece.maxwell_merm_shrine.chance,
        enabled = configurations.set_piece.maxwell_merm_shrine.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "MaxMermShrine", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.MARSH )
        end,
    },
    
    maxwell_pig_shrine =
    {
        count = configurations.set_piece.maxwell_pig_shrine.count,
        chance = configurations.set_piece.maxwell_pig_shrine.chance,
        enabled = configurations.set_piece.maxwell_pig_shrine.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "MaxPigShrine", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.FOREST )
        end,
    },
    
    mimic =
    {
        count = configurations.set_piece.mimic.count,
        chance = configurations.set_piece.mimic.chance,
        enabled = configurations.set_piece.mimic.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "mimic", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    mushroom_rings =
    {
        enabled = configurations.set_piece.mushroom_rings.enabled,
        load = function(count, chance)
            local MushroomRingSizes =
            {
                Small = 0,
                Medium = 1,
                Large = 2,
            }
            for k, v in pairs(MushroomRingSizes) do
                Map.CreateSetPiece( Map.LEVELTYPE.ALL, "MushroomRing"..k, Map.LAYOUT_TYPE.RANDOM )
            end
        end,
    },
    
    -- N
    -- O
    -- P   
    pig_town =
    {
        count = configurations.set_piece.pig_town.count,
        chance = configurations.set_piece.pig_town.chance,
        enabled = configurations.set_piece.pig_town.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "PigTown", Map.LAYOUT_TYPE.GROUND, count, chance, "Any" )
        end,
    },    

    pigguards =
    {
        count = configurations.set_piece.pigguards.count,
        chance = configurations.set_piece.pigguards.chance,
        enabled = configurations.set_piece.pigguards.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "PigGuards", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    pigguards_easy = 
    {
        count = configurations.set_piece.pigguards_easy.count,
        chance = configurations.set_piece.pigguards_easy.chance,
        enabled = configurations.set_piece.pigguards_easy.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "PigGuardsEasy", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    -- Q
    -- R
    resurrection_stone_lit =
    {
        count = configurations.set_piece.resurrection_stone_lit.count,
        chance = configurations.set_piece.resurrection_stone_lit.chance,
        enabled = configurations.set_piece.resurrection_stone_lit.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "ResurrectionStoneLit", Map.LAYOUT_TYPE.GROUND, count, chance, "Any" )
        end,
    },
    
    ruined_base =
    {
        count = configurations.set_piece.ruined_base.count,
        chance = configurations.set_piece.ruined_base.chance,
        enabled = configurations.set_piece.ruined_base.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "RuinedBase", Map.LAYOUT_TYPE.RANDOM )
        end,
    },
    
    -- S
    seasonal_retaliation =
    {
        count = configurations.set_piece.seasonal_retaliation.count,
        chance = configurations.set_piece.seasonal_retaliation.chance,
        enabled = configurations.set_piece.seasonal_retaliation.chance > 0,
        load = function(count, chance)
            local season_set_pieces_enabled = configurations.world_generation.set_pieces.seasonal
            
            if season_set_pieces_enabled then
                Map.CreateSetPiece( Map.LEVELTYPE.ALL, "seasonal_retaliation", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
            end
        end,
    },
    
    simple_base =
    {
        count = configurations.set_piece.simple_base.count,
        chance = configurations.set_piece.simple_base.chance,
        enabled = configurations.set_piece.simple_base.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "SimpleBase", Map.LAYOUT_TYPE.RANDOM )
        end,
    },
    
    stone_henge =
    {
        enabled = configurations.set_piece.stone_henge.enabled,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "StoneHenge", Map.LAYOUT_TYPE.RANDOM )
        end,
    },
    -- T
    torch_pigking =
    {
        count = configurations.set_piece.torch_pigking.count,
        chance = configurations.set_piece.torch_pigking.chance,
        enabled = configurations.set_piece.torch_pigking.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "TorchPigking", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.FOREST )
        end,
    },
    -- U
    -- V
    village_square = 
    {
        count = configurations.set_piece.village_square.count,
        chance = configurations.set_piece.village_square.chance,
        enabled = configurations.set_piece.village_square.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "VillageSquare", Map.LAYOUT_TYPE.GROUND, count, chance, GROUND.GRASS )
        end,
    },
    
    -- W
    wealthy_graves =
    {
        count = configurations.set_piece.wealthy_graves.count,
        chance = configurations.set_piece.wealthy_graves.chance,
        enabled = configurations.set_piece.wealthy_graves.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "wealthy_graves", Map.LAYOUT_TYPE.ROOM, count, chance, "Graveyard" )
        end,
    },
    
    winter_revival =
    {
        count = configurations.set_piece.winter_revival.count,
        chance = configurations.set_piece.winter_revival.chance,
        enabled = configurations.set_piece.winter_revival.chance > 0,
        load = function(count, chance)
            Map.CreateSetPiece( Map.LEVELTYPE.ALL, "winter_revival", Map.LAYOUT_TYPE.GROUND, count, chance, "Any" )
        end,
    },
    
    -- X
    -- Y
    -- Z
    

    
}



-- use "data/layouts/random/set_pieces/insane_pighouse"

-- use "data/layouts/random/set_pieces/grotto"
-- use "data/layouts/random/set_pieces/fisher_pig"
-- use "data/layouts/random/set_pieces/insane_eyebone"
--use "data/layouts/random/set_pieces/misc"
-- use "data/layouts/random/set_pieces/eyebone_grave"

