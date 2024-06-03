GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

TUNING.MYTH_WORDS_MOD_OPEN = true --全局变量方便别的mod获取

PrefabFiles = {
	"mk_items",
	"bananafan",
	"myth_fx",
	"purple_gourd",
	"myth_door_exit",
	"myth_door_enter",
	"myth_floor",
	"myth_wall",
	"myth_zodiac",
	"myth_xingyue",
	"myth_interiors",
	"book_fly_myth",
	"myth_dengfire",
	"myth_smalllight",
	"myth_banana_tree",
	"myth_bundle",
	"myth_zongzi",
	"bananafan_big",
	"myth_flyskill",
	
	"myth_ghg",
	"myth_interiors_ghg",
	"myth_chang_e",
	"myth_redlantern",
	"myth_redlantern_ground",
	"myth_ruyi",
	"myth_fence",
	"myth_bbn",
	"myth_mooncake",
	"myth_ghg_snow",
	"myth_yylp",
	"myth_goldfrog",
	"myth_coin",
	"myth_treasure_bowl",
	"myth_cash_tree",
	"myth_redpouch",
	"myth_goldnugget_ingot",
	"myth_small_goldfrog",
	"myth_goldfrog_spawner",
	"myth_goldfrog_base",
	"myth_farm_spawn",
	"myth_yjp",
	"myth_granary",
	"myth_well",
	"myth_toys",
	"myth_tudi_shrines",
	"myth_tudi",
	"myth_food_table",
	"myth_honeypot",
	"myth_rock_ghgice",
	"laozi_qingniu",
	"saddle_qingniu",
	"laozi_bell",
	"myth_qxj",

	--荷花
	"myth_lotusleaf_hat",
	"myth_lotusleaf",
	"myth_siving",
	"armor_siving",
	"siving_hat",
	"myth_lotus_flower",
	"myth_plant_lotus",
	"myth_weapon_syf",
	"myth_weapon_syd",
	"myth_weapon_gtt",
	"krampussack_sealed",
	"myth_rhino_heart",
	"myth_siving_boss",
	"myth_fuchen",
	"myth_store", 
	"myth_store_construction",

	"myth_statue_pandaman",
	"myth_bamboo",
	"myth_plant_bamboo",
	"myth_hotmeter",
	"myth_gale_sparkle_vfx",

	"myth_passcard_jie",
	"rhino_shoutfx",
	"myth_rhino_fx",
	"myth_rhino_firefx",

	"myth_huanhundan",
	"yama_fire_purple",
	"yama_fire_green",
	"yama_fire_yellow",
	"myth_mooncake_box",
	"myth_coin_box",
}

Assets = {
	Asset( "IMAGE", "images/monkey_king_item.tex" ),
    Asset( "ATLAS", "images/monkey_king_item.xml" ),

	Asset("ATLAS_BUILD", "images/monkey_king_item.xml", 256),
	
    Asset( "ATLAS", "images/inventoryimages/myth_banana_tree.xml" ),

	Asset( "ATLAS", "images/inventoryimages/myth_flyskill.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_mk.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_pg.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_nz.xml" ),	
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_wb.xml" ),	
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_yj.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_yt.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_flyskill_ya.xml" ),
	Asset( "ATLAS", "images/hud/myth_tab.xml" ),
	Asset( "IMAGE", "images/hud/myth_tab.tex" ),
	Asset( "ATLAS", "images/hud/myth_tab_change.xml" ),
	Asset( "IMAGE", "images/hud/myth_tab_change.tex" ),	
    Asset("ANIM", "anim/gourd_items.zip"),

    Asset("ANIM", "anim/purple_gourd.zip"),
    Asset("ANIM", "anim/myth_peruse.zip"), --读书
    Asset("ANIM", "anim/myth_wrap_bundle.zip"),	--打包
	  
	Asset("SOUNDPACKAGE", "sound/buttons.fev"),
	Asset("SOUND", "sound/myth_jssound.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/bianzhong.fev"),
    Asset("SOUND", "sound/bianzhong.fsb"),

	Asset("SOUNDPACKAGE", "sound/myth_icon_sound.fev"),
    Asset("SOUND", "sound/myth_icon_sound.fsb"),

	Asset("SOUNDPACKAGE", "sound/mythsound_rhino.fev"),
    Asset("SOUND", "sound/mythsound_rhino.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/bamboo_clappers.fev"),
    Asset("SOUND", "sound/bamboo_clappers.fsb"),
	Asset("SOUNDPACKAGE", "sound/crane.fev"),
    Asset("SOUND", "sound/crane.fsb"),
}

local mk_map_icons = {
	"peachtree",
	"mk_battle_flag",
	"alchmy_fur",
	"laozi",
	"myth_rhino_desk",
	"fangcunhill",
	"myth_banana_tree",
	"myth_ghg",
	"myth_yylp",
	"myth_treasure_bowl",
	"myth_cash_tree_ground",
	"myth_goldfrog_base",
	"myth_yjp",
	"myth_granary",
	"myth_well",
	"myth_tudi_shrines",
	"myth_food_table",
	"myth_honeypot",
	"laozi_bell",
	"myth_plant_bamboo",
	"myth_lotus_flower",

}
for k,v in pairs(mk_map_icons) do
	table.insert(Assets, Asset( "IMAGE", "images/map_icons/"..v..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/map_icons/"..v..".xml" ))
    AddMinimapAtlas("images/map_icons/"..v..".xml")
end

local mk_skin_assets = {
	"alchmy_fur","alchmy_fur_copper","alchmy_fur_ruins","redlantern_myth_a","redlantern_myth_b","redlantern_myth_c","redlantern_myth_d",
	"swap_redlantern_myth_a","swap_redlantern_myth_b","swap_redlantern_myth_c","swap_redlantern_myth_d","myth_granary","myth_well",
	"redlantern_myth_e","swap_redlantern_myth_e",
	"myth_interiors_ghg_groundlight_bgz","myth_interiors_ghg_groundlight_blz","myth_interiors_ghg_groundlight_llt",
	"myth_interiors_ghg_groundlight_qzh","myth_interiors_ghg_groundlight_ryx","myth_interiors_ghg_groundlight_std",
	"myth_interiors_ghg_groundlight_gxy","myth_interiors_ghg_groundlight_yhy",
}
for _,v in ipairs(mk_skin_assets) do
	table.insert(Assets, Asset("DYNAMIC_ANIM", "anim/dynamic/"..v..".zip"))
    table.insert(Assets, Asset("PKGREF", "anim/dynamic/"..v..".dyn"))
end


function AddPrefabFiles(...)
	for _,v in ipairs({...})do table.insert(PrefabFiles, v) end
end

--------------------------------------------------------------------------
--[[ 语言设置 ]]
--------------------------------------------------------------------------

AddReplicableComponent("myth_show_hotmeter")

local MK_MOD_LANGUAGE_SETTING = "CHINESE"

if GetModConfigData('Language') ~= 'A' then
	MK_MOD_LANGUAGE_SETTING = GetModConfigData('Language') --不是自动就是他了
else
	--检测系统语言
	local loc = require "languages/loc"
	local lan = loc and loc.GetLanguage and loc.GetLanguage()
	if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL then --自动的话找中文
		MK_MOD_LANGUAGE_SETTING = "CHINESE"
	else
		MK_MOD_LANGUAGE_SETTING = "ENGLISH"
	end
end
if type(MK_MOD_LANGUAGE_SETTING) == "boolean" then --旧版服务器的设置会保留以前的值
	MK_MOD_LANGUAGE_SETTING = "CHINESE"
end
GLOBAL.MK_MOD_LANGUAGE_SETTING = MK_MOD_LANGUAGE_SETTING

TUNING.MYTH_TREASURE_BOWL = {}

cache_fns = {}
function Myth_AddCachedStr(fn)
	table.insert(cache_fns, fn)
end
GLOBAL.Myth_AddCachedStr = Myth_AddCachedStr

function GLOBAL.Myth_RunCachedStr()--Called by character mod
	for _,fn in ipairs(cache_fns) do fn() end
end
--------------------------------------------------------------------------
--[[ 功能 ]]
--------------------------------------------------------------------------

local rwms = require "languages/strings_myth_theme_rwms"
if MK_MOD_LANGUAGE_SETTING == "CHINESE" then
	modimport("scripts/languages/strings_myth_theme_chs.lua")
	rwms("chs")
elseif MK_MOD_LANGUAGE_SETTING == "JAPAN" then
	modimport("scripts/languages/strings_myth_theme_ja.lua")
	rwms("ja")
elseif MK_MOD_LANGUAGE_SETTING == "VI" then
	modimport("scripts/languages/strings_myth_theme_vi.lua")
	rwms("vi")
else
	modimport("scripts/languages/strings_myth_theme_en.lua")
	rwms("en")
end

local function import(t)
	for _,v in ipairs(t)do modimport("main/"..v) end
end

import{
	'sg',
	'actions',
	'containers',
	'equips',
	'foods',
	'tech',

	'flag',
	'laozi',
	'peach',
	'pills',
	'plantable',
	"blackbear",
	"rhino",
	"components",
	'etc',
	'mythhouse',
	'mk_flyer',
	"mod_rpc",
	"prefabpostInit",
	"myth_bookinfo",
	"myth_lotus",
	"myth_newturf",
	"registerinventoryitematlas",
	--'hot',
}

if GetModConfigData('ShowBuff') then
	import{"myth_buff_ly_api"}
end
--------------------------------------------------------------------------
--[[ 制作配方 ]]
--------------------------------------------------------------------------

local MKRECIPE = AddRecipeTab( STRINGS.MKRECIPE, 611, "images/hud/myth_tab.xml", "myth_tab.tex")
RECIPETABS.MKCERECIPE = { str = STRINGS.MKCERECIPE,	sort = 100, icon_atlas = "images/hud/myth_tab_change.xml" ,icon = "myth_tab_change.tex",	crafting_station = true }


GLOBAL.MKRECIPE = CUSTOM_RECIPETABS[STRINGS.MKRECIPE]

local function myth_granarytestfn(pt)
	local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(pt.x, 0, pt.z)
	for _, ent in ipairs(ents) do
		if not ent:HasTag("player") and not (ent:HasTag("NOBLOCK") or ent:HasTag("locomotor") or ent:HasTag("NOCLICK") or ent:HasTag("FX") or ent:HasTag("DECOR")) then
			return false
		end
	end
	return true
end
local function myth_tuditestfn(inst)
	return not(TheWorld.net and TheWorld.net.myth_tudimiao:value())
end


AddRecipe("book_myth", {Ingredient("papyrus", 2)}, MKRECIPE, TECH.MAGIC_THREE,
nil, nil, nil, nil, nil,
"images/inventoryimages/book_myth.xml", "book_myth.tex")

AddRecipe("mk_battle_flag_item",{Ingredient("boards", 2),Ingredient("silk", 9),Ingredient("houndstooth", 6)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "mk_battle_flag_item.tex")

AddRecipe("cassock",{Ingredient("silk", 9),Ingredient("manrabbit_tail", 3),Ingredient("slurper_pelt", 3)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "cassock.tex")

AddRecipe("kam_lan_cassock",{Ingredient("cassock", 1,"images/monkey_king_item.xml"),Ingredient("bearger_fur", 1),Ingredient("dragon_scales", 1)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "kam_lan_cassock.tex")

AddRecipe("xzhat_mk",{Ingredient("manrabbit_tail", 2),Ingredient("beeswax", 1),Ingredient("silk", 6)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "xzhat_mk.tex")

AddRecipe("pill_bottle_gourd",{Ingredient("gourd", 1,"images/monkey_king_item.xml"),Ingredient("rope", 2),Ingredient("beeswax", 1)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "pill_bottle_gourd.tex")

AddRecipe("wine_bottle_gourd",{Ingredient("gourd", 1,"images/monkey_king_item.xml"),Ingredient("peach_wine", 5,"images/monkey_king_item.xml"),Ingredient("beeswax", 1)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/monkey_king_item.xml", "wine_bottle_gourd.tex")

AddRecipe("myth_well",{Ingredient("cutstone", 3),Ingredient("pickaxe", 1),Ingredient("shovel", 1)}, RECIPETABS.FARM, TECH.SCIENCE_TWO,
"myth_well_placer", 2, nil, nil, nil,
"images/map_icons/myth_well.xml", "myth_well.tex",myth_granarytestfn)

--土地
AddRecipe("myth_tudi_shrines",{Ingredient("cutstone", 3),Ingredient("boards", 4),Ingredient("mole", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO,
"myth_tudi_shrines_placer", 2, nil, nil, nil,
"images/map_icons/myth_tudi_shrines.xml", "myth_tudi_shrines.tex",myth_tuditestfn)

AddRecipe("myth_food_table",{Ingredient("boards", 6)}, RECIPETABS.FARM, TECH.SCIENCE_ONE,
"myth_food_table_placer", 4, nil, nil, nil,
"images/map_icons/myth_food_table.xml", "myth_food_table.tex")

AddRecipe("myth_granary",{Ingredient("boards", 6),Ingredient("cutreeds", 12),Ingredient("rope", 3)}, RECIPETABS.FARM, TECH.SCIENCE_ONE,
"myth_granary_placer", 0, nil, nil, nil,
"images/map_icons/myth_granary.xml", "myth_granary.tex",myth_granarytestfn)


AddRecipe("alchmy_fur",{Ingredient("thulecite", 6),Ingredient("cutstone", 6),Ingredient("dragon_scales", 2)}, MKRECIPE,  TECH.MYTH_TECH,
"alchmy_fur_placer", 2, nil, nil, nil,
"images/monkey_king_item.xml", "alchmy_fur.tex")

AddRecipe("myth_banana_tree",{Ingredient("cave_banana", 1),Ingredient("livinglog", 1),Ingredient("fertilizer", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO,
"myth_banana_tree_placer", 2.5, nil, nil, nil,
"images/inventoryimages/myth_banana_tree.xml", "myth_banana_tree.tex",function(pt, rot) return TheWorld.Map:CanPlantAtPoint(pt:Get()) end )

AddRecipe("myth_bundlewrap",{Ingredient("myth_banana_leaf", 2,"images/inventoryimages/myth_banana_leaf.xml")}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO,
nil, nil, nil, nil, nil,
"images/inventoryimages/myth_bundlewrap.xml", "myth_bundlewrap.tex")

AddRecipe("myth_zongzi1",{Ingredient("vegetarian_food", 1,"images/monkey_king_item.xml"),Ingredient("myth_banana_leaf", 1,"images/inventoryimages/myth_banana_leaf.xml"),Ingredient("rope", 1)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/inventoryimages/myth_zongzi1.xml", "myth_zongzi1.tex")

AddRecipe("myth_zongzi2",{Ingredient("meatballs", 1),Ingredient("myth_banana_leaf", 1,"images/inventoryimages/myth_banana_leaf.xml"),Ingredient("rope", 1)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/inventoryimages/myth_zongzi2.xml", "myth_zongzi2.tex")

--月饼盒子
AddRecipe("myth_mooncake_box",{Ingredient("boards", 2),
Ingredient("moon_tree_blossom", 1)}, MKRECIPE,  TECH.MYTH_TECH,
nil, nil, nil, nil, nil,
"images/inventoryimages/myth_mooncake_box.xml", "myth_mooncake_box.tex")


--摇钱树
AddRecipe("myth_cash_tree_ground_recipe",{Ingredient("myth_cash_tree", 1,"images/inventoryimages/myth_cash_tree.xml"),
Ingredient("myth_coin", 66,"images/inventoryimages/myth_coin.xml"),Ingredient("lucky_goldnugget", 66)}, MKRECIPE,  TECH.MYTH_TECH,
"myth_cash_tree_ground_placer", 3.5, nil, nil, nil,
"images/inventoryimages/myth_cash_tree_ground.xml", "myth_cash_tree_ground.tex",nil,"myth_cash_tree_ground")

--灯笼
AddRecipe("myth_redlantern",{Ingredient("beeswax", 1),Ingredient("twigs", 3),Ingredient("papyrus", 2)}, RECIPETABS.LIGHT,  TECH.LOST,
nil, nil, nil, nil, nil,
"images/inventoryimages/redlantern_myth_a.xml", "redlantern_myth_a.tex")

--灯笼架
AddRecipe("myth_redlantern_ground",{Ingredient("boards", 2),Ingredient("charcoal", 1)}, RECIPETABS.TOWN,  TECH.LOST,
"myth_redlantern_ground_placer", 1.5, nil, nil, nil,
"images/inventoryimages/myth_redlantern_ground.xml", "myth_redlantern_ground.tex")

--AddRecipe("myth_redlantern_ground_right",{Ingredient("boards", 2),Ingredient("charcoal", 1)}, RECIPETABS.TOWN,  TECH.LOST,
--"myth_redlantern_ground_right_placer", 1.5, nil, nil, nil,
--"images/inventoryimages/myth_redlantern_ground_right.xml", "myth_redlantern_ground_right.tex")

--STRINGS.NAMES.MYTH_REDLANTERN_GROUND_RIGHT = STRINGS.NAMES.MYTH_REDLANTERN_GROUND
--STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND_RIGHT =STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN_GROUND_RIGHT =STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN_GROUND

--大栅栏
AddRecipe("myth_fence_item",{Ingredient("boards", 3),Ingredient("silk", 3),Ingredient("papyrus", 3)}, RECIPETABS.TOWN,  TECH.LOST,
nil, nil, nil, 3, nil,
"images/inventoryimages/myth_fence_item.xml", "myth_fence_item.tex")

--月宫配方
AddRecipe("myth_fence_item_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_ONE,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_redlantern_ground_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_TWO,nil,  nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_redlantern_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_THREE,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")

AddRecipe("myth_interiors_ghg_flower_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_ONE,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_interiors_ghg_groundlight_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_THREE,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_interiors_ghg_he_left_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_TWO,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_interiors_ghg_he_right_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_TWO,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")
AddRecipe("myth_interiors_ghg_lu_blueprint",{Ingredient("papyrus", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_ONE,nil, nil, true, nil, nil,"images/inventoryimages1.xml", "blueprint_rare.tex")

--如意如意
AddRecipe("myth_ruyi",{Ingredient("opalpreciousgem", 1),Ingredient("moonglass", 3)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_THREE,
nil, nil, true, nil, nil,
"images/inventoryimages/myth_ruyi.xml", "myth_ruyi.tex")

--百宝囊
AddRecipe("myth_bbn",{Ingredient("silk", 7),Ingredient("moon_tree_blossom", 16),Ingredient("opalpreciousgem", 1)}, RECIPETABS.MKCERECIPE,  TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_FOUR,
nil, nil, true, nil, nil,
"images/inventoryimages/myth_bbn_full.xml", "myth_bbn_full.tex")

--月宫宫灯
AddRecipe("myth_interiors_ghg_groundlight",{Ingredient("myth_redlantern", 1,"images/inventoryimages/redlantern_myth_a.xml",nil,"redlantern_myth_a.tex"),Ingredient("boards", 1)},RECIPETABS.TOWN,  TECH.LOST,
{placer = "myth_interiors_ghg_groundlight_placer",no_deconstruction = true }, 2, nil, nil, nil,
"images/inventoryimages/myth_interiors_ghg_groundlight.xml", "myth_interiors_ghg_groundlight.tex")


--月宫盆景
AddRecipe("myth_interiors_ghg_flower",{Ingredient("twigs", 3),Ingredient("moonbutterfly", 1),Ingredient("moonglass", 4)},RECIPETABS.TOWN,  TECH.LOST,
"myth_interiors_ghg_flower_placer", 2, nil, nil, nil,
"images/inventoryimages/myth_interiors_ghg_flower.xml", "myth_interiors_ghg_flower.tex")

--月宫仙鹤左
AddRecipe("myth_interiors_ghg_he_left",{Ingredient("moonrocknugget", 4),Ingredient("malbatross_feather", 1)},RECIPETABS.TOWN,  TECH.LOST,
"myth_interiors_ghg_he_left_placer", 2, nil, nil, nil,
"images/inventoryimages/myth_interiors_ghg_he_left.xml", "myth_interiors_ghg_he_left.tex")

--月宫仙鹤右
AddRecipe("myth_interiors_ghg_he_right",{Ingredient("moonrocknugget", 4),Ingredient("malbatross_feather", 1)},RECIPETABS.TOWN,  TECH.LOST,
"myth_interiors_ghg_he_right_placer", 2, nil, nil, nil,
"images/inventoryimages/myth_interiors_ghg_he_right.xml", "myth_interiors_ghg_he_right.tex")

--月宫香炉
AddRecipe("myth_interiors_ghg_lu",{Ingredient("petals", 6),Ingredient("moonrocknugget", 2),Ingredient("charcoal", 1)},RECIPETABS.TOWN,  TECH.LOST,
"myth_interiors_ghg_lu_placer", 2, nil, nil, nil,
"images/inventoryimages/myth_interiors_ghg_lu.xml", "myth_interiors_ghg_lu.tex")

--荷叶伞
AddRecipe("myth_lotusleaf_hat",{Ingredient("myth_lotusleaf", 1,"images/inventoryimages/myth_lotusleaf.xml"),Ingredient("rope", 1)},RECIPETABS.DRESS,  TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/myth_lotusleaf_hat.xml", "myth_lotusleaf_hat.tex")

--草皮
AddRecipe("turf_myth_zhu",{Ingredient("myth_bamboo", 3)},RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE,
nil, nil, true, nil, nil,
"images/inventoryimages/turf_myth_zhu.xml", "turf_myth_zhu.tex")

AddRecipe("turf_quagmire_parkfield",{Ingredient("peach", 3)},RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE,
nil, nil, true, nil, nil,
"images/inventoryimages/turf_quagmire_parkfield.xml", "turf_quagmire_parkfield.tex")

--竹子做纸
AddRecipe("myth_papyrus",{Ingredient("myth_bamboo", 6)},RECIPETABS.REFINE, TECH.SCIENCE_ONE,
nil, nil, nil, 2, nil,
nil,nil,nil, "papyrus")
STRINGS.NAMES.MYTH_PAPYRUS = STRINGS.NAMES.PAPYRUS

--飞行术

--通用
AddRecipe("myth_flyskill",{Ingredient("fly_pill", 1,"images/monkey_king_item.xml")}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "myth_flyskill",
"images/inventoryimages/myth_flyskill.xml", "myth_flyskill.tex")

AddRecipe("myth_flyskill_sanity",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.NONE,
nil, nil, nil, nil, "nobody",
"images/inventoryimages/myth_flyskill.xml", "myth_flyskill.tex",nil,"myth_flyskill")
STRINGS.NAMES.MYTH_FLYSKILL_SANITY = STRINGS.NAMES.MYTH_FLYSKILL

AddRecipe("myth_flyskill_mk",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "monkey_king",
"images/inventoryimages/myth_flyskill_mk.xml", "myth_flyskill_mk.tex")

AddRecipe("myth_flyskill_nz",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "neza",
"images/inventoryimages/myth_flyskill_nz.xml", "myth_flyskill_nz.tex")

AddRecipe("myth_flyskill_wb",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "white_bone",
"images/inventoryimages/myth_flyskill_wb.xml", "myth_flyskill_wb.tex")

AddRecipe("myth_flyskill_pg",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "pigsy",
"images/inventoryimages/myth_flyskill_pg.xml", "myth_flyskill_pg.tex")

AddRecipe("myth_flyskill_yj",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "yangjian",
"images/inventoryimages/myth_flyskill_yj.xml", "myth_flyskill_yj.tex")

AddRecipe("myth_flyskill_yt",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "myth_yutu",
"images/inventoryimages/myth_flyskill_yt.xml", "myth_flyskill_yt.tex")

AddRecipe("myth_flyskill_ya",{Ingredient(CHARACTER_INGREDIENT.SANITY, 25)}, MKRECIPE,  TECH.LOST,
nil, nil, nil, nil, "yama_commissioners",
"images/inventoryimages/myth_flyskill_ya.xml", "myth_flyskill_ya.tex")

modimport("main/myth_skins.lua")
--modimport("main/logupload.lua")