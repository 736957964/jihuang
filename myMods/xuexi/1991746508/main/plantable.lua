
--新作物 葫芦
if GROUND.FARMING_SOIL ~= nil then  --新版的农场
AddPrefabFiles("myth_new_gourd", "wine_bottle_gourd", "pill_bottle_gourd")
local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity, float_settings, cooked_float_settings, dryable, secondary_foodtype, halloweenmoonmutable_settings, lure_data)
    return {
        health = health,
        hunger = hunger,
        cooked_health = cooked_health,
        cooked_hunger = cooked_hunger,
        seed_weight = seedweight,
        perishtime = perish_time,
        cooked_perishtime = cooked_perish_time,
        sanity = sanity,
        cooked_sanity = cooked_sanity,
        float_settings = float_settings,
        cooked_float_settings = cooked_float_settings,
		dryable = dryable,
		halloweenmoonmutable_settings = halloweenmoonmutable_settings,
		secondary_foodtype = secondary_foodtype,
        lure_data = lure_data,
    }
end
AddSimPostInit(function()
	if GLOBAL.VEGGIES ~= nil then
		VEGGIES.gourd = MakeVegStats(TUNING.SEED_CHANCE_RARE, 37.5, 3, TUNING.PERISH_MED, 0, 37.5, 8,  TUNING.PERISH_FAST, 0)
	end
end)

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

--是你 福禄娃！
local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time = {}

	-- germination time
	grow_time.seed		= {germination_min, germination_max}

	-- grow time
	grow_time.sprout	= {full_grow_min * 0.5, full_grow_max * 0.5}
	grow_time.small		= {full_grow_min * 0.3, full_grow_max * 0.3}
	grow_time.med		= {full_grow_min * 0.2, full_grow_max * 0.2}

	-- harvestable perish time
	grow_time.full		= 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized	= 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow	= {4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME} -- min, max

	return grow_time
end

local drink_low = TUNING.FARM_PLANT_DRINK_LOW
local drink_med = TUNING.FARM_PLANT_DRINK_MED
local drink_high = TUNING.FARM_PLANT_DRINK_HIGH
-- Nutrients
local S = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

PLANT_DEFS.gourd = {
	--贴图
	build = "farm_plant_gourd", 
	bank = "farm_plant_gourd",
	--生长时间
	grow_time = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME,		4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME),
	--潮湿度
	moisture = {drink_rate = drink_med,	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE},
	--适应的季节
	good_seasons = {autumn = true},
	--需求的肥料
	nutrient_consumption = {0, 0, M},
	--会生成的肥料
	nutrient_restoration = {true,true,nil},
	--好感度
	max_killjoys_tolerance	= TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
	--是否免疫火
	--fireproof = true,
	--称重
	weight_data	= { 666.66,     888.88,     2.34 },
	--植物代码
	prefab = "farm_plant_gourd",
	--产物
	product = "gourd",
	--巨大产物
	product_oversized = "gourd_oversized",
	--种子
	seed = "gourd_seeds",
	--标签
	plant_type_tag = "farm_plant_gourd",
	--腐烂产物(大型的腐烂)
	loot_oversized_rot = {"spoiled_food", "spoiled_food", "spoiled_food", "gourd_seeds", "fruitfly", "fruitfly"},
	--家族化需求的数量(也就是家族化检索距离里面至少有几个才可以长出来巨大型的最少数量 默认4)
	family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	--家族化检索距离(默认4)
	family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	--状态的net(如果你的植物状态超过了7个阶段 换别的net)
	stage_netvar = net_tinybyte,
	--生长图谱 (hidden 表示这个阶段不显示)
	sounds = PLANT_DEFS.pumpkin.sounds,
	plantregistryinfo = {
		{
			text = "seed",
			anim = "crop_seed",
			grow_anim = "grow_seed",
			learnseed = true,
			growing = true,
		},
		{
			text = "sprout",
			anim = "crop_sprout",
			grow_anim = "grow_sprout",
			growing = true,
		},
		{
			text = "small",
			anim = "crop_small",
			grow_anim = "grow_small",
			growing = true,
		},
		{
			text = "medium",
			anim = "crop_med",
			grow_anim = "grow_med",
			growing = true,
		},
		{
			text = "grown",
			anim = "crop_full",
			grow_anim = "grow_full",
			revealplantname = true,
			fullgrown = true,
		},
		{
			text = "oversized",
			anim = "crop_oversized",
			grow_anim = "grow_oversized",
			revealplantname = true,
			fullgrown = true,
		},
		{
			text = "rotting",
			anim = "crop_rot",
			grow_anim = "grow_rot",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},
		{
			text = "oversized_rotting",
			anim = "crop_rot_oversized",
			grow_anim = "grow_rot_oversized",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},
	},
	--界面相关  官方支持mod使用自己的界面
	plantregistrywidget = "widgets/redux/farmplantpage",
	plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget",
	pictureframeanim = {anim = "emoteXL_happycheer", time = 0.5} ,
}
end