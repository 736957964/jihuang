--[[    Copyright © 2015 Ysovuka/Kzisor  ]]

configurations =
{
	world_generation =
	{
		random_set_pieces =
		{
			amount = GetModConfigData("world_generation.random_set_pieces.amount") or 5,
		},

		set_pieces =
		{
			seasonal = GetModConfigData("world_generation.set_pieces.seasonal") or false,
		},
	},

	set_piece =
	{
		beefalo_farm =
		{
			chance = GetModConfigData("set_piece.beefalo_farm.chance") or 10,
			count = GetModConfigData("set_piece.beefalo_farm.count") or 1,
		},

		koalefant_farm =
		{
			chance = GetModConfigData("set_piece.koalefant_farm.chance") or 10,
			count = GetModConfigData("set_piece.koalefant_farm.count") or 1,
		},
		
		calamity_camp =
		{
			chance = GetModConfigData("set_piece.calamity_camp.chance") or 10,
			count = GetModConfigData("set_piece.calamity_camp.count") or 1,
		},

		colourful_mushroom_farm =
		{
			chance = GetModConfigData("set_piece.colourful_mushroom_farm.chance") or 10,
			count = GetModConfigData("set_piece.colourful_mushroom_farm.count") or 1,
		},

		conquering_pigs =
		{
			chance = GetModConfigData("set_piece.conquering_pigs.chance") or 10,
			count = GetModConfigData("set_piece.conquering_pigs.count") or 1,
		},

		healthy_resources =
		{
			chance = GetModConfigData("set_piece.healthy_resources.chance") or 10,
			count = GetModConfigData("set_piece.healthy_resources.count") or 1,
		},
		
		mushroom_rings =
		{
		    enabled = GetModConfigData("set_piece.mushroom_rings.enabled") or true,
		},

		mimic =
		{
			chance = GetModConfigData("set_piece.mimic.chance") or 10,
			count = GetModConfigData("set_piece.mimic.count") or 1,
		},

		seasonal_retaliation =
		{
			chance = GetModConfigData("set_piece.seasonal_retaliation.chance") or 50,
			count = GetModConfigData("set_piece.seasonal_retaliation.count") or 3,
		},

		example =
		{
			chance = GetModConfigData("set_piece.example.chance") or 10,
			count = GetModConfigData("set_piece.example.count") or 1,
		},

		winter_revival =
		{
			chance = GetModConfigData("set_piece.winter_revival.chance") or 100,
			count = GetModConfigData("set_piece.winter_revival.count") or 2,
		},

		wealthy_graves =
		{
			chance = GetModConfigData("set_piece.wealthy_graves.chance") or 10,
			count = GetModConfigData("set_piece.wealthy_graves.count") or 1,
		},

		mushroom_ring_small =
		{
			chance = GetModConfigData("set_piece.mushroom_ring_small.chance") or 10,
			count = GetModConfigData("set_piece.mushroom_ring_small.count") or 1,
		},

		mushroom_ring_medium =
		{
			chance = GetModConfigData("set_piece.mushroom_ring_medium.chance") or 10,
			count = GetModConfigData("set_piece.mushroom_ring_medium.count") or 1,
		},

		mushroom_ring_large =
		{
			chance = GetModConfigData("set_piece.mushroom_ring_large_.chance") or 10,
			count = GetModConfigData("set_piece.mushroom_ring_large.count") or 1,
		},

		fairy_rings =
		{
			enabled = GetModConfigData("set_piece.fairy_rings.enabled") or true,
		},

		stone_henge =
		{
			enabled = GetModConfigData("set_piece.stone_henge.enabled") or true,
		},

		maxwell_merm_shrine =
		{
			chance = GetModConfigData("set_piece.maxwell_merm_shrine.chance") or 10,
			count = GetModConfigData("set_piece.maxwell_merm_shrine.count") or 1,
		},

		maxwell_pig_shrine =
		{
			chance = GetModConfigData("set_piece.maxwell_pig_shrine.chance") or 10,
			count = GetModConfigData("set_piece.maxwell_pig_shrine.count") or 1,
		},

		mactusk_city =
		{
			chance = GetModConfigData("set_piece.mactusk_city.chance") or 10,
			count = GetModConfigData("set_piece.mactusk_city.count") or 1,
		},

		mactusk_town =
		{
			chance = GetModConfigData("set_piece.mactusk_town.chance") or 10,
			count = GetModConfigData("set_piece.mactusk_town.count") or 1,
		},

		insane_flint =
		{
			chance = GetModConfigData("set_piece.insane_flint.chance") or 10,
			count = GetModConfigData("set_piece.insane_flint.count") or 1,
		},

		simple_base =
		{
			chance = GetModConfigData("set_piece.simple_base.chance") or 100,
			count = GetModConfigData("set_piece.simple_base.count") or 1,
		},

		hound_rocks =
		{
			chance = GetModConfigData("set_piece.hound_rocks.chance") or 10,
			count = GetModConfigData("set_piece.hound_rocks.count") or 1,
		},

		pig_town =
		{
			chance = GetModConfigData("set_piece.pig_town.chance") or 10,
			count = GetModConfigData("set_piece.pig_town.count") or 1,
		},

		ruined_base =
		{
			chance = GetModConfigData("set_piece.ruined_base.chance") or 10,
			count = GetModConfigData("set_piece.ruined_base.count") or 1,
		},

		village_square =
		{
			chance = GetModConfigData("set_piece.village_square.chance") or 10,
			count = GetModConfigData("set_piece.village_square.count") or 1,
		},

		resurrection_stone_lit =
		{
			chance = GetModConfigData("set_piece.resurrection_stone_lit.chance") or 100,
			count = GetModConfigData("set_piece.resurrection_stone_lit.count") or 2,
		},

		torch_pigking =
		{
			chance = GetModConfigData("set_piece.torch_pigking.chance") or 10,
			count = GetModConfigData("set_piece.torch_pigking.count") or 1,
		},

		pigguards_easy =
		{
			chance = GetModConfigData("set_piece.pigguards_easy.chance") or 10,
			count = GetModConfigData("set_piece.pigguards_easy.count") or 1,
		},

		pigguards =
		{
			chance = GetModConfigData("set_piece.pigguards.chance") or 10,
			count = GetModConfigData("set_piece.pigguards.count") or 1,
		},
	},
}