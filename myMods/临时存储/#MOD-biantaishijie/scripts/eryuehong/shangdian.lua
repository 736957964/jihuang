

if true then

if GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated() then

SpawnPrefab = GLOBAL.SpawnPrefab
FindWalkableOffset = GLOBAL.FindWalkableOffset
PI = GLOBAL.PI
GetRandomItem = GLOBAL.GetRandomItem
GetRandomMinMax = GLOBAL.GetRandomMinMax
TheSim = GLOBAL.TheSim
FindEntity = GLOBAL.FindEntity
TUNING = GLOBAL.TUNING
ACTIONS = GLOBAL.ACTIONS
TheNet = GLOBAL.TheNet
deepcopy = GLOBAL.deepcopy
MakeSnowCovered = GLOBAL.MakeSnowCovered
MakeObstaclePhysics = GLOBAL.MakeObstaclePhysics
SetSharedLootTable = GLOBAL.SetSharedLootTable
EQUIPSLOTS = GLOBAL.EQUIPSLOTS
Vector3 = GLOBAL.Vector3
FindClosestPlayerInRange = GLOBAL.FindClosestPlayerInRange
COLLISION = GLOBAL.COLLISION
GetClosestInstWithTag = GLOBAL.GetClosestInstWithTag
RemovePhysicsColliders = GLOBAL.RemovePhysicsColliders


local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 2

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

SetSharedLootTable( 'lucky_goldnugget',--巨型元宝矿
{
	{'rocks',  1.00},   
	{'rocks',  1.00},  
	{'rocks',  0.50},
	{'lucky_goldnugget',  1},
	{'lucky_goldnugget',  0.5},
}
)

local function shop_weighted_random_choice(choices)--加权获取随机物品(重写主要为了方便商店出售物品的随机获取)
--这里的weight指的是selllist中的table
    local function weighted_total(choices)
        local total = 0
        for choice, weight in pairs(choices) do
            total = total + weight.chance
        end
        return total
    end

    local threshold = math.random() * weighted_total(choices)
    
    local last_choice
    for choice, weight in pairs(choices) do
        threshold = threshold - weight.chance
        if threshold <= 0 then return weight end
        last_choice = weight
    end
    
    return weight
end

local selllist = {--所有商店中可能刷新出的物品,prefab物品代码，name该物品中文名字，chance出现几率，price基础单件价值，num基础存货，n单次购买可获取物品数，reduce购买一次消耗经验数，magic(魔法锦囊对应物品,这逼装的不错233)
--{prefab = "deerclops_eyeball",name = "巨鹿眼球",chance = 10,price = 20, num = 3,n = 1,reduce = 40},
--{prefab = "minotaurhorn",name = "犀牛角",chance = 3,price = 80, num = 2,n = 1,reduce = 60},
--{prefab = "eyeturret_item",name = "眼球塔",chance = 4,price = 40, num = 2,n = 1,reduce = 80},
{prefab = "thulecite",name = "铥矿",chance = 12,price = 1, num = 20,n = 1,reduce = 5},
--{prefab = "papyrus",name = "莎草纸",chance = 15,price = 2, num = 20,n = 1,reduce = 5},
--{prefab = "royal_jelly",name = "蜂王浆",chance = 12,price = 3, num = 20,n = 1,reduce = 10},
--{prefab = "manrabbit_tail",name = "兔子毛",chance = 12,price = 1, num = 20,n = 2,reduce = 8},
{prefab = "mandrake",name = "曼德拉草",chance = 10,price = 2, num = 5,n = 1,reduce = 8},
--{prefab = "hivehat",name = "蜂后帽",chance = 10,price = 10, num = 2,n = 1,reduce = 10},
--{prefab = "dragon_scales",name = "火蜻蜓鳞片",chance = 10,price = 10, num = 5,n = 1,reduce = 8},
--{prefab = "shroom_skin",name = "蛤蟆皮",chance = 8,price = 8, num = 4,n = 1,reduce = 15},
--{prefab = "dragonflyfurnace_blueprint",name = "龙鳞烤炉蓝图",chance = 8,price = 20, num = 2,n = 1,reduce = 25},
--{prefab = "red_mushroomhat_blueprint",name = "红蘑菇帽子蓝图",chance = 6,price = 16, num = 2,n = 1,reduce = 40},
--{prefab = "green_mushroomhat_blueprint",name = "绿蘑菇帽子蓝图",chance = 6,price = 16, num = 2,n = 1,reduce = 40},
--{prefab = "blue_mushroomhat_blueprint",name = "蓝蘑菇帽子蓝图",chance = 6,price = 16, num = 2,n = 1,reduce = 40},
--{prefab = "mushroom_light2_blueprint",name = "发光器蓝图",chance = 4,price = 25, num = 2,n = 1,reduce = 60},
--{prefab = "mushroom_light_blueprint",name = "蘑菇灯蓝图",chance = 4,price = 20, num = 2,n = 1,reduce = 50},
--{prefab = "bearger_fur",name = "熊皮",chance = 10,price = 10, num = 3,n = 1,reduce = 20},
--{prefab = "nightmarefuel",name = "噩梦燃料",chance = 15,price = 2, num = 10,n = 5,reduce = 10},
--{prefab = "goose_feather",name = "鸭子毛",chance = 15,price = 2, num = 10,n = 4,reduce = 10},
{prefab = "lavae_egg",name = "岩浆虫卵",chance = 15,price = 2, num = 3,n = 1,reduce = 10},
--{prefab = "steelwool",name = "钢羊毛",chance = 10,price = 2, num = 5,n = 1,reduce = 15},
--{prefab = "rocks",name = "石头",chance = 20,price = 1, num = 10,n = 10,reduce = 10},
{prefab = "bluegem",name = "蓝宝石",chance = 18,price = 1.5, num = 5,n = 1,reduce = 30},
{prefab = "redgem",name = "红宝石",chance = 18,price = 1.5, num = 5,n = 1,reduce = 30},
{prefab = "purplegem",name = "紫宝石",chance = 16,price = 3, num = 5,n = 2,reduce = 50},
{prefab = "orangegem",name = "橙宝石",chance = 12,price = 3, num = 5,n = 1,reduce = 35},
{prefab = "yellowgem",name = "黄宝石",chance = 12,price = 3, num = 5,n = 1,reduce = 35},
{prefab = "greengem",name = "绿宝石",chance = 8,price = 10, num = 5,n = 1,reduce = 50},
{prefab = "moonrocknugget",name = "月石",chance = 15,price = 3, num = 4,n = 2,reduce = 35},
{prefab = "fossil_piece",name = "化石",chance = 18,price = 1, num = 4,n = 1,reduce = 45},
{prefab = "opalpreciousgem",name = "闪闪发亮的宝石",chance = 8,price = 10, num = 5,n = 1,reduce = 55},
--{prefab = "slurper_pelt",name = "啜食者皮",chance = 8,price = 2, num = 5,n = 1,reduce = 30},
--{prefab = "pigskin",name = "猪皮",chance = 16,price = 1, num = 5,n = 2,reduce = 20},
--{prefab = "silk",name = "蜘蛛丝",chance = 16,price = 1, num = 8,n = 3,reduce = 30},
--{prefab = "butterflywings",name = "蝴蝶翅膀",chance = 16,price = 2, num = 6,n = 8,reduce = 40},
--{prefab = "butterfly",name = "蝴蝶",chance = 16,price = 8, num = 8,n = 3,reduce = 40},
--{prefab = "ice",name = "冰块",chance = 16,price = 2, num = 15,n = 4,reduce = 60},
--{prefab = "nitre",name = "硝石",chance = 16,price = 2, num = 5,n = 5,reduce = 45},
--{prefab = "livinglog",name = "活木",chance = 16,price = 1.5, num = 3,n = 3,reduce = 45},
--{prefab = "batbat",name = "蝙蝠棒",chance = 14,price = 2.5, num = 3,n = 1,reduce = 30},
--{prefab = "ruins_bat",name = "铥矿棒",chance = 14,price = 6, num = 3,n = 1,reduce = 45},
--{prefab = "nightsword",name = "影刀",chance = 12,price = 3, num = 3,n = 1,reduce = 30},
{prefab = "cane",name = "行动手杖",chance = 12,price = 4, num = 3,n = 1,reduce = 30},
--{prefab = "orangestaff",name = "懒惰的探索者",chance = 10,price = 4, num = 3,n = 1,reduce = 40},
--{prefab = "yellowstaff",name = "星星权杖",chance = 10,price = 4, num = 3,n = 1,reduce = 30},
--{prefab = "greenstaff",name = "分解法杖",chance = 10,price = 16, num = 3,n = 1,reduce = 45},
{prefab = "opalstaff",name = "呼月权杖",chance = 10,price = 6, num = 3,n = 1,reduce = 40},
--{prefab = "multitool_axe_pickaxe",name = "镐斧",chance = 10,price = 2, num = 3,n = 1,reduce = 20},
{prefab = "orangeamulet",name = "懒惰的强盗",chance = 10,price = 3, num = 2,n = 1,reduce = 30},
--{prefab = "yellowamulet",name = "魔力之光",chance = 10,price = 3, num = 3,n = 1,reduce = 32},
{prefab = "greenamulet",name = "建设护符",chance = 10,price = 12, num = 4,n = 1,reduce = 45},
{prefab = "walrushat",name = "海象帽",chance = 18,price = 1.5, num = 4,n = 1,reduce = 20},
{prefab = "molehat",name = "鼹鼠帽",chance = 18,price = 1.5, num = 3,n = 1,reduce = 20},
--{prefab = "wormlight",name = "发光浆果",chance = 15,price = 3, num = 3,n = 6,reduce = 45},
{prefab = "gears",name = "齿轮",chance = 15,price = 2, num = 4,n = 7,reduce = 45},
{prefab = "whip",name = "猫尾鞭",chance = 15,price = 1.5, num = 3,n = 1,reduce = 30},
--{prefab = "armor_sanity",name = "影甲",chance = 15,price = 3.5, num = 3,n = 1,reduce = 30},
--{prefab = "armormarble",name = "大理石甲",chance = 15,price = 3.5, num = 3,n = 1,reduce = 30},
--{prefab = "armorsnurtleshell",name = "蜗牛壳",chance = 10,price = 4.5, num = 3,n = 1,reduce = 30},
{prefab = "armorruins",name = "铥矿甲",chance = 10,price = 5, num = 3,n = 1,reduce = 30},
--{prefab = "armordragonfly",name = "火甲",chance = 10,price = 3, num = 3,n = 1,reduce = 30},
{prefab = "slurtlehat",name = "蜗牛帽",chance = 10,price = 4.5, num = 3,n = 1,reduce = 30},
--{prefab = "slurtle_shellpieces",name = "蜗牛壳碎片",chance = 10,price = 3, num = 3,n = 5,reduce = 30},
--{prefab = "slurtleslime",name = "蜗牛粘液",chance = 15,price = 2, num = 5,n = 5,reduce = 35},
--{prefab = "gunpowder",name = "火药",chance = 15,price = 2, num = 8,n = 3,reduce = 35},
--{prefab = "lightninggoathorn",name = "电羊角",chance = 8,price = 5, num = 4,n = 1,reduce = 35},
--{prefab = "goatmilk",name = "羊奶",chance = 12,price = 2, num = 4,n = 2,reduce = 50},
--{prefab = "dug_berrybush_juicy",name = "多汁浆果丛的根",chance = 12,price = 2, num = 5,n = 3,reduce = 50},
--{prefab = "butter",name = "黄油",chance = 12,price = 3, num = 5,n = 2,reduce = 50},
--{prefab = "honeycomb",name = "蜂巢",chance = 12,price = 2, num = 5,n = 2,reduce = 50},
{prefab = "krampus_sack",name = "小偷包",chance = 6,price = 25, num = 2,n = 1,reduce = 60},
--{prefab = "winter_treestand_blueprint",name = "圣诞树花盆蓝图",chance = 100,price = 400, num = 2,n = 1,reduce = 1200},--纯属彩蛋了，一般人估计也买不起，出现几率只有炮塔的5%
--{prefab = "townportal_blueprint",name = "传送仪蓝图",chance = 6,price = 6, num = 2,n = 1,reduce = 30},
{prefab = "endtable_blueprint",name = "茶几蓝图",chance = 6,price = 10, num = 2,n = 1,reduce = 30},
--{prefab = "bernie_inactive",name = "伯尼",chance = 6,price = 2, num = 2,n = 1,reduce = 40},
--{prefab = "giftwrap_blueprint",name = "礼物包装纸蓝图",chance = 3,price = 12, num = 2,n = 1,reduce = 100},
--{prefab = "cactus_flower",name = "仙人掌花",chance = 10,price = 2, num = 5,n = 8,reduce = 20},
--{prefab = "candybag_blueprint",name = "糖果袋子蓝图",chance = 3,price = 8, num = 2,n = 1,reduce = 100},
{prefab = "goggleshat_blueprint",name = "时髦目镜蓝图",chance = 6,price = 5, num = 2,n = 1,reduce = 50},
{prefab = "deserthat_blueprint",name = "沙漠目镜蓝图",chance = 6,price = 5, num = 2,n = 1,reduce = 50},
--{prefab = "armorskeleton",name = "骷髅护甲",chance = 2,price = 8, num = 3,n = 1,reduce = 50},
{prefab = "bundlewrap_blueprint",name = "包装纸蓝图",chance = 2,price = 15, num = 2,n = 1,reduce = 200},
{prefab = "succulent_potted_blueprint",name = "多肉的盆栽蓝图",chance = 3,price = 12, num = 3,n = 1,reduce = 50},
{prefab = "shadowheart",name = "暗影心脏",chance = 10,price = 7, num = 5,n = 1,reduce = 50},
--{prefab = "thurible",name = "暗影香炉",chance = 8,price = 8, num = 4,n = 1,reduce = 40},
--原版不可携带类
{prefab = "redpouch",name = "魔法锦囊『圣诞树盆』",chance = 6,price = 10, num = 2,n = 1,reduce = 50,magic = "winter_treestand"},
--{prefab = "redpouch",name = "魔法锦囊『芦苇』",chance = 10,price = 7, num = 4,n = 1,reduce = 25,magic = "reeds"},
{prefab = "redpouch",name = "魔法锦囊『洞穴苔藓』",chance = 10,price = 7, num = 4,n = 1,reduce = 20,magic = "lichen"},
{prefab = "redpouch",name = "魔法锦囊『单荧光花』",chance = 8,price = 4, num = 3,n = 1,reduce = 30,magic = "flower_cave"},
{prefab = "redpouch",name = "魔法锦囊『双荧光花』",chance = 8,price = 7, num = 3,n = 1,reduce = 40,magic = "flower_cave_double"},
{prefab = "redpouch",name = "魔法锦囊『三荧光花』",chance = 8,price = 10, num = 3,n = 1,reduce = 50,magic = "flower_cave_triple"},
{prefab = "redpouch",name = "魔法锦囊『仙人球』",chance = 5,price = 12, num = 1,n = 1,reduce = 50,magic = "cactus"},
{prefab = "redpouch",name = "魔法锦囊『仙人掌』",chance = 5,price = 12, num = 1,n = 1,reduce = 50,magic = "oasis_cactus"},
{prefab = "redpouch",name = "魔法锦囊『洞穴香蕉树』",chance = 5,price = 12, num = 1,n = 1,reduce = 50,magic = "cave_banana_tree"},
{prefab = "redpouch",name = "魔法锦囊『巨型元宝』",chance = 3,price = 15, num = 1,n = 1,reduce = 50,magic = "lucky_goldnugget"},
{prefab = "redpouch",name = "魔法锦囊『准战斗牛』",chance = 4,price = 30, num = 1,n = 1,reduce = 50,magic = "beefalo",info = "半战"},
{prefab = "redpouch",name = "魔法锦囊『准骑行牛』",chance = 4,price = 25, num = 1,n = 1,reduce = 30,magic = "beefalo",info = "半骑"},
{prefab = "redpouch",name = "魔法锦囊『准宠物牛』",chance = 4,price = 20, num = 1,n = 1,reduce = 20,magic = "beefalo",info = "半宠"},
{prefab = "redpouch",name = "魔法锦囊『战斗牛』",chance = 3,price = 50, num = 1,n = 1,reduce = 100,magic = "beefalo",info = "全战"},
{prefab = "redpouch",name = "魔法锦囊『骑行牛』",chance = 3,price = 40, num = 1,n = 1,reduce = 60,magic = "beefalo",info = "全骑"},
{prefab = "redpouch",name = "魔法锦囊『宠物牛』",chance = 3,price = 30, num = 1,n = 1,reduce = 40,magic = "beefalo",info = "全宠"},
{prefab = "redpouch",name = "魔法锦囊『电羊』",chance = 2,price = 50, num = 1,n = 1,reduce = 200,magic = "lightninggoat"},
{prefab = "redpouch",name = "魔法锦囊『狸猫树洞』",chance = 3,price = 15, num = 2,n = 1,reduce = 50,magic = "catcoonden"},
{prefab = "redpouch",name = "魔法锦囊『圣诞彩灯』",chance = 4,price = 10, num = 2,n = 1,reduce = 50,magic = "light"},
--{prefab = "redpouch",name = "整蛊锦囊『迷宫箱子』",chance = 3,price = 10, num = 3,n = 1,reduce = 50,magic = "pandoraschest"},
--{prefab = "redpouch",name = "整蛊锦囊『豪华箱子』",chance = 3,price = 15, num = 3,n = 1,reduce = 50,magic = "minotaurchest"},
--{prefab = "redpouch",name = "整蛊锦囊『骷髅箱子』",chance = 3,price = 20, num = 3,n = 1,reduce = 50,magic = "skullchest"},
--{prefab = "redpouch",name = "绝版锦囊『永恒雕像』",chance = 0,price = 0, num = 0,n = 0,reduce = 0,magic = "dragonflyepic"},--无法从商店得到，而是作为一种全新的特殊奖励

}

local function getinfo(shop)--将商店的信息转化成文字
	if shop.page == 1 then
	local hoverstring = "-----商店信息-----"
	local liststring = ""
	local timestring = GLOBAL.TheWorld.state.isday and "☀ " or "☆ "
	for i,v in pairs(shop.shoplist) do
		liststring = liststring .. "\n" .. timestring .. v.name .. "*" .. tostring(v.n) .. "  单份价格 " .. tostring(v.price) .. " 库存 " .. tostring(v.num) .. "份"
	end
	if #shop.shoplist == 0 then
		liststring = "\n已售罄"
	end
	local soldstring = shop.solditem and "\n当前出售 --> " .. shop.solditem.name or "\n当前无出售物品"
	local levelstring = "\n当前商店等级:" .. tostring(shop.lr_level) .. "  经验:" .. tostring(shop.lr_exp)
	return hoverstring .. liststring .. soldstring .. "\n" .. "当前收购倍率:" .. tostring(shop.buy_multi) .. "\n" .. "当前零钱剩余:" .. tostring(shop.shopodd) .. levelstring
	else
		local otherstring = "\n给予火龙果派刷新出售物品\n给予曼德拉汤刷新商店库存\n给予金元宝获取当前出售物品\n给予浆果或蜜汁浆果升级商店\n给予其他物品获取红包\n全图随机刷新各种宝石矿石\n魔法锦囊打开后在原地生成对应物品\n身上有格子时『包括背包』优先在身上生成"
		return "-----使用说明-----" .. otherstring
	end
end

local function getselllist(oldselllist,level)--从上面的列表中获取包含与商店等级相关数量的随机的物品出售列表
	local preselllist = oldselllist --初始化出售列表
	local newselllist = {}--最终获取的商店出售列表
	local num = level and level + 1 or 1
	local multiplier = 0.5 + level/10--商店各物资库存量倍率

	local function inlist(value,list)
		for i,v in pairs(list) do
			if v.name == value.name then
				return true
			end
		end
		return false
	end
	for i = 1,num do
		local goods
		repeat goods = deepcopy(shop_weighted_random_choice(preselllist))--保证货物不重复
		until not inlist(goods,newselllist)
		goods.price = goods.price * 1  ---(math.random(90 ,140)/100)--基础价格的0.9~1.4倍间取随机数保证价格的随机波动
		goods.num = math.ceil((goods.num * (math.random(50,180)/100)) * multiplier)--库存在0.5~1.8倍之间随机波动(向上取整)
		table.insert(newselllist,goods)
	end
	return newselllist
end

local chests =
{
    skullchest =
    {
        bank = "skull_chest",
        build = "skull_chest",
    },
    pandoraschest =
    {
        bank = "pandoras_chest",
        build = "pandoras_chest",
    },
    minotaurchest =
    {
        bank = "pandoras_chest_large",
        build = "pandoras_chest_large",
    },
}

local function newonunwrappedfn(inst, pos, doer)
	if inst.magictype and not inst.burnt then
		if inst.magictype == "pandoraschest" or inst.magictype == "minotaurchest" or inst.magictype == "skullchest" then
			local chest = GetClosestInstWithTag("chest", inst, 20)
			if chest and chest:IsValid() then
				local x,y,z = chest.Transform:GetWorldPosition()
				SpawnPrefab("statue_transition").Transform:SetPosition(x,y,z)
				chest.magicskin = inst.magictype
				chest.AnimState:SetBank(chests[chest.magicskin].bank)
				chest.AnimState:SetBuild(chests[chest.magicskin].build)
				if chest.prefab == "storeroom" then--地窖移除碰撞体积
					RemovePhysicsColliders(chest)
				end
			end
			SpawnPrefab("redpouch_unwrap").Transform:SetPosition(pos:Get())
			if doer ~= nil and doer.SoundEmitter ~= nil then
				doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
			end
			inst:Remove()
			return
		end
		local item
		if inst.magictype == "winter_treestand" then
			item = SpawnPrefab("winter_treestand")
			item.shop_owner = doer.userid
		elseif inst.magictype == "reeds" then
			item = SpawnPrefab("reeds")
			item.shop_owner = doer.userid
		elseif inst.magictype == "lichen" then
			item = SpawnPrefab("lichen")
			item.shop_owner = doer.userid
		elseif inst.magictype == "flower_cave" then
			item = SpawnPrefab("flower_cave")
			item.shop_owner = doer.userid
		elseif inst.magictype == "flower_cave_double" then
			item = SpawnPrefab("flower_cave_double")
			item.shop_owner = doer.userid
		elseif inst.magictype == "flower_cave_triple" then
			item = SpawnPrefab("flower_cave_triple")
			item.shop_owner = doer.userid
		elseif inst.magictype == "cactus" then
			item = SpawnPrefab("cactus")
			item.shop_owner = doer.userid
		elseif inst.magictype == "oasis_cactus" then
			item = SpawnPrefab("oasis_cactus")
			item.shop_owner = doer.userid
		elseif inst.magictype == "cave_banana_tree" then
			item = SpawnPrefab("cave_banana_tree")
			item.shop_owner = doer.userid
		elseif inst.magictype == "catcoonden" then
			item = SpawnPrefab("catcoonden")
			item.shop_owner = doer.userid
		elseif inst.magictype == "dragonflyepic" then
			item = SpawnPrefab("ruins_statue_mage")
			item.addlr_light = true
			if item.components.workable then
				item.components.workable:SetWorkable(false)
			end
			if item.components.lr_light == nil then--利用原版蘑菇树的发光机制制造出光芒
				item:AddComponent("lr_light")
			end
			item.components.lr_light:MakeMachine()--可开关灯源
			item.components.lr_light:Start()
			item:DoPeriodicTask(3,function()
				local x,y,z = item.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z,50)
				for i,v in pairs(ents) do 
					if v:HasTag("player") then
						if not v.components.health:IsDead() then
							v.components.health:DoDelta(1)
							v.components.sanity:DoDelta(1)
						end
					end
				end
			end)
		elseif inst.magictype == "beefalo" then
			item = SpawnPrefab("beefalo")
			item.components.hunger:DoDelta(200)
			if inst.magicinfo == "半战" then
				item.components.domesticatable:DeltaTendency("ORNERY", 5)
				item.components.domesticatable.domestication = math.random(40,80)/100
				item.components.domesticatable.obedience = 1
			elseif inst.magicinfo == "半骑" then
				item.components.domesticatable:DeltaTendency("RIDER", 5)
				item.components.domesticatable.domestication = math.random(40,80)/100
				item.components.domesticatable.obedience = 1		
			elseif inst.magicinfo == "半宠" then
				item.components.domesticatable:DeltaTendency("PUDGY", 5)
				item.components.domesticatable.domestication = math.random(40,80)/100
				item.components.domesticatable.obedience = 1			
			elseif inst.magicinfo == "全战" then
				item.components.domesticatable:DeltaTendency("ORNERY", 10)
				item:SetTendency()
				item.components.domesticatable.domestication = 1
				item.components.domesticatable:BecomeDomesticated()
			elseif inst.magicinfo == "全骑" then
				item.components.domesticatable:DeltaTendency("RIDER", 10)
				item:SetTendency()
				item.components.domesticatable.domestication = 1
				item.components.domesticatable:BecomeDomesticated()
			elseif inst.magicinfo == "全宠" then
				item.components.domesticatable:DeltaTendency("PUDGY", 10)
				item:SetTendency()
				item.components.domesticatable.domestication = 1
				item.components.domesticatable:BecomeDomesticated()
			end
		elseif inst.magictype == "lightninggoat" then
			item = SpawnPrefab("lightninggoat")
		elseif inst.magictype == "lucky_goldnugget" then
			item = SpawnPrefab("lucky_goldnugget")
			item.shop_owner = doer.userid
			item.shop_tobig = true
			item.Transform:SetScale(6,6,6)
			if item.components.inventoryitem then
				item:RemoveComponent("inventoryitem")
			end
			if item.components.workable == nil then
				item:AddComponent("workable")
			end
			if item.components.lootdropper == nil then
				item:AddComponent("lootdropper")
			end
			if item.components.named == nil then
				item:AddComponent("named")
			end
			item.components.named:SetName("金元宝矿")
			item.components.lootdropper:SetChanceLootTable("lucky_goldnugget")
			MakeSnowCovered(item)
			MakeObstaclePhysics(item, 1)
			item.components.workable:SetWorkAction(ACTIONS.MINE)
			item.components.workable:SetWorkLeft(20)
			item.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
				local pt = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
				if worker == nil then
					inst.components.workable.workleft = inst.components.workable.workleft + 1
				end
				if worker.babydata then
					if worker.components.talker then
						worker.components.talker:Say("宝宝还太小，敲不破这东西!")
					end
					inst.components.workable.workleft = inst.components.workable.workleft + 1
				end
				if worker and worker.components.inventory then
					local tool = worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				end
				if tool and tool.prefab ~= "multitool_axe_pickaxe" then
					if tool.prefab == "pickaxe" then
						if worker.components.talker then
							worker.components.talker:Say("我想我手里的工具还不足以将其破坏!")
						end
						inst.components.workable.workleft = inst.components.workable.workleft + 1
					else
						if worker.components.talker then
							worker.components.talker:Say("这并不是最好的开采工具，但我想我可以敲碎它!")
						end
						inst.components.workable.workleft = inst.components.workable.workleft + 0.66				
					end
				end
				if workleft <= 0 then
					inst.components.lootdropper:DropLoot(pt)
					inst:Remove()
				end
			end)
		end
		if inst.magictype == "light" then
			SpawnPrefab("winter_ornament_light1").Transform:SetPosition(pos:Get())
			SpawnPrefab("winter_ornament_light2").Transform:SetPosition(pos:Get())
			SpawnPrefab("winter_ornament_light3").Transform:SetPosition(pos:Get())
			SpawnPrefab("winter_ornament_light4").Transform:SetPosition(pos:Get())
		else
			if item then
				item.Transform:SetPosition(pos:Get())
			end
		end
		local fx = SpawnPrefab("spawn_fx_medium")
		fx.Transform:SetPosition(pos:Get())
        SpawnPrefab("redpouch_unwrap").Transform:SetPosition(pos:Get())
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
        inst:Remove()
	else
        if inst.burnt then
            SpawnPrefab("ash").Transform:SetPosition(pos:Get())
        else
            local loottable = { "lucky_goldnugget" }
            if loottable ~= nil then
                local moisture = inst.components.inventoryitem:GetMoisture()
                local iswet = inst.components.inventoryitem:IsWet()
                for i, v in ipairs(loottable) do
                    local item = SpawnPrefab(v)
                    if item ~= nil then
                        if item.Physics ~= nil then
                            item.Physics:Teleport(pos:Get())
                        else
                            item.Transform:SetPosition(pos:Get())
                        end
                        if item.components.inventoryitem ~= nil then
                            item.components.inventoryitem:InheritMoisture(moisture, iswet)
                            if tossloot then
                                item.components.inventoryitem:OnDropped(true, .5)
                            end
                        end
                    end
                end
            end
            SpawnPrefab("redpouch_unwrap").Transform:SetPosition(pos:Get())
        end
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
        inst:Remove()
	end
end

local function pouch_onsave(inst,data)--保存加载特殊红包数据
	if inst.shop_onsave then
		inst.shop_onsave(inst,data)
	end
	data.magicname = inst.magicname
	data.magictype = inst.magictype
	data.magicinfo = inst.magicinfo
end

local function pouch_onload(inst,data)
	if data ~= nil then
		if inst.shop_onload then
			inst.shop_onload(inst,data)
		end
		inst.magicname = data.magicname
		inst.magictype = data.magictype
		inst.magicinfo = data.magicinfo
		if inst.magictype and inst.magicname then 
			if inst.components.named == nil then
				inst:AddComponent("named")
			end
			inst.components.named:SetName(inst.magicname)
			inst.components.unwrappable.onunwrappedfn = newonunwrappedfn
		end
	end
end

local function MakeMagicPouch(type,name,info)--特殊红包生成
	local pouch = SpawnPrefab("redpouch")
	pouch.magicname = name--红包名字
	if pouch.components.named == nil then
		pouch:AddComponent("named")
	end
	pouch.components.named:SetName(pouch.magicname)
	pouch.magictype = type
	pouch.magicinfo = info
	pouch.components.unwrappable.onunwrappedfn = newonunwrappedfn
	return pouch
end

AddPrefabPostInit("redpouch",function(inst)--修改红包代码
	inst.shop_onsave = inst.OnSave
	inst.OnSave = pouch_onsave
	inst.shop_onload = inst.OnLoad
	inst.OnLoad = pouch_onload
end)

local function lucky_goldnugget_onsave(inst,data)--保存加载特殊红包数据
	if inst.shop_onsave then
		inst.shop_onsave(inst,data)
	end
	data.shop_tobig = inst.shop_tobig
end

local function lucky_goldnugget_onload(inst,data)
	if data ~= nil then
		if inst.shop_onload then
			inst.shop_onload(inst,data)
		end
		inst.shop_tobig = data.shop_tobig
		if inst.shop_tobig == true then
			inst.Transform:SetScale(6,6,6)
			if inst.components.inventoryitem then
				inst:RemoveComponent("inventoryitem")
			end
			if inst.components.workable == nil then
				inst:AddComponent("workable")
			end
			if inst.components.lootdropper == nil then
				inst:AddComponent("lootdropper")
			end
			if inst.components.named == nil then
				inst:AddComponent("named")
			end
			inst.components.named:SetName("金元宝矿")
			inst.components.lootdropper:SetChanceLootTable("lucky_goldnugget")
			MakeSnowCovered(inst)
			MakeObstaclePhysics(inst, 2)
			inst.components.workable:SetWorkAction(ACTIONS.MINE)
			inst.components.workable:SetWorkLeft(20)
			inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
				local pt = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
				if worker == nil then
					inst.components.workable.workleft = inst.components.workable.workleft + 1
				end
				if worker.babydata then
					if worker.components.talker then
						worker.components.talker:Say("宝宝还太小，敲不破这东西!")
					end
					inst.components.workable.workleft = inst.components.workable.workleft + 1
				end
				if worker and worker.components.inventory then
					local tool = worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				end
				if tool and tool.prefab ~= "multitool_axe_pickaxe" then
					if tool.prefab == "pickaxe" then
						if worker.components.talker then
							worker.components.talker:Say("我想我手里的工具还不足以将其破坏!")
						end
						inst.components.workable.workleft = inst.components.workable.workleft + 1
					else
						if worker.components.talker then
							worker.components.talker:Say("这并不是最好的开采工具，但我想我可以敲碎它!")
						end
						inst.components.workable.workleft = inst.components.workable.workleft + 0.66			
					end
				end
				if workleft <= 0 then
					inst.components.lootdropper:DropLoot(pt)
					inst:Remove()
				end
			end)
		end
	end
end

AddPrefabPostInit("lucky_goldnugget",function(inst)--巨型金元宝
	inst.shop_onsave = inst.OnSave
	inst.OnSave = lucky_goldnugget_onsave
	inst.shop_onload = inst.OnLoad
	inst.OnLoad = lucky_goldnugget_onload
end)

local function buy(item,money,buyer,shop)--item出售物品，money金元宝+余额
	price = item.price
	if money >= price then
		shop.sellrecord[buyer.userid] = shop.sellrecord[buyer.userid] and shop.sellrecord[buyer.userid] + 1 or 1
		if shop.sellrecord[buyer.userid] >= 50 and buyer.components.talker then
			buyer.components.talker:Say("已达到购买上限")
		end
		local _item = SpawnPrefab(item.prefab)
		local leftnum = buyer.components.inventory:CanAcceptCount(_item,item.n)--还可以装下的该物品数
		_item:Remove()
		if item.magic then
			if buyer.userid == "KU_3RvV-M6_" and item.magic == "light"  then
				for i=1,5 do 
					buyer.components.inventory:GiveItem(SpawnPrefab("lucky_goldnugget"))
				end
			end
			if leftnum >= 1 then--如果身上满了就在地上生成物品
				for i = 1,item.n do
					buyer.components.inventory:GiveItem(MakeMagicPouch(item.magic,item.name,item.info))--魔法锦囊生成特殊红包
				end
			else
				if leftnum > 0 then
					for i = 1,leftnum do 
						buyer.components.inventory:GiveItem(MakeMagicPouch(item.magic,item.name,item.info))
					end
					for i = 1,item.n - leftnum do
						local pt = GetSpawnPoint(shop:GetPosition())
						MakeMagicPouch(item.magic,item.name,item.info).Transform:SetPosition(pt.x,pt.y,pt.z)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
					end
				else
					for i = 1,item.n do
						local pt = GetSpawnPoint(shop:GetPosition())
						MakeMagicPouch(item.magic,item.name,item.info).Transform:SetPosition(pt.x,pt.y,pt.z)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
					end	
				end
			end	
		else
			if leftnum >= item.n then--如果身上满了就在地上生成物品
				for i = 1,item.n do
					buyer.components.inventory:GiveItem(SpawnPrefab(item.prefab))
				end
			else
				if leftnum > 0 then
					for i = 1,leftnum do 
						buyer.components.inventory:GiveItem(SpawnPrefab(item.prefab))
					end
					for i = 1,item.n - leftnum do
						local pt = GetSpawnPoint(shop:GetPosition())
						SpawnPrefab(item.prefab).Transform:SetPosition(pt.x,pt.y,pt.z)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
					end
				else
					for i = 1,item.n do
						local pt = GetSpawnPoint(shop:GetPosition())
						SpawnPrefab(item.prefab).Transform:SetPosition(pt.x,pt.y,pt.z)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
					end	
				end
			end
		end
		if buyer.components.talker then
			buyer.components.talker:Say("花费" .. tostring(price) .. "个金元宝『成功购买』物品【" .. item.name .. "】*" .. tostring(item.n))
		end
		TheNet:Announce("☂  " .. buyer:GetDisplayName() .. "花费" .. tostring(price) .. "个金元宝『成功购买』物品【" .. item.name .. "】*" .. tostring(item.n))
		shop.shopodd = money - price
		if shop.shopodd >= 1 then
			for i = 1,math.floor(shop.shopodd) do
				buyer.components.inventory:GiveItem(SpawnPrefab("lucky_goldnugget"))
			end
			shop.shopodd = shop.shopodd - math.floor(shop.shopodd)
		end
		if buyer.hxleveldata then
			buyer.hxleveldata.exp = buyer.hxleveldata.exp - item.reduce
			if buyer.components.talker then
				buyer:DoTaskInTime(1.5,function()
					buyer.components.talker:Say("[购买物品]\n[经验值消耗] " .. tostring(item.reduce))
				end)
			end
		end
		shop.solditem.num = shop.solditem.num - 1
		for i,v in pairs(shop.shoplist) do
			if v.name == shop.solditem.name then
				if v.num <= 0 then
					shop.shoplist[i] = nil
				end
				break
			end
		end
		if shop.solditem.num <= 0 then
			shop.solditem = GetRandomItem(shop.shoplist)
		end
	else
		if buyer.components.talker then
			buyer.components.talker:Say("我想这点钱还不够")
		end
		shop.shopodd = money
	end
	shop.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
end

local function TrySpawnMoney(inst)
    if not (inst.components.burnable ~= nil and
            (inst.components.burnable:IsBurning() or inst.components.burnable:IsSmoldering()) or
            inst:HasTag("burnt")) and
        GLOBAL.TheWorld.state.isday and
        FindEntity(inst, 5, nil, { "currency" }) == nil then--只能有一个金元宝，否则不生成
		local pt = GetSpawnPoint(inst:GetPosition())
		SpawnPrefab("lucky_goldnugget").Transform:SetPosition(pt.x,pt.y,pt.z)
		SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
    end
end

local function OnStartDay(inst)--12级以后可以在附近生成金元宝
	if math.random() < 0.8 then  --20%可以生成一个金元宝
		inst:DoTaskInTime(GetRandomMinMax(3, 5), TrySpawnMoney)
	end
end

local getmoneylist = {--物品换钱的列表(辛苦控制台了~)
{prefab = "mole",name = "鼹鼠",value = 0.1 },
{prefab = "turf_road",name = "卵石路",value = 0.1 },
{prefab = "halloweencandy_7",name = "葡萄干",value = 0.1 },
{prefab = "halloweencandy_9",name = "果冻虫",value = 0.1 },
{prefab = "turf_savanna",name = "热带草原地皮",value = 0.1 },
{prefab = "minifan",name = "回旋扇",value = 0.1 },
{prefab = "hambat",name = "火腿棍",value = 0.1 },
{prefab = "dug_berrybush_juicy",name = "多汁浆果丛",value = 0.1 },
{prefab = "dug_marsh_bush",name = "荆棘丛",value = 0.1 },
{prefab = "drumstick_cooked",name = "炸鸡腿",value = 0.1 },
{prefab = "gunpowder",name = "火药",value = 0.1 },
{prefab = "humanmeat",name = "人肉",value = 0.1 },
{prefab = "dragontailhat",name = "幸运野兽尾巴",value = 0.10 },
{prefab = "shroom_skin",name = "魔蛤皮",value = 0.1 },
{prefab = "brush",name = "洗刷",value = 0.10 },
{prefab = "honeyham",name = "蜜汁火腿",value = 0.1 },
{prefab = "amulet",name = "重生护符",value = 0.2 },
{prefab = "stinger",name = "蛰刺",value = 0.1 },
{prefab = "pumpkin",name = "大南瓜",value = 0.1 },
{prefab = "wormlight_lesser",name = "微光浆果",value = 0.1 },
{prefab = "beargervest",name = "熊皮背心",value = 0.1 },
{prefab = "waterballoon",name = "水球",value = 0.1 },
{prefab = "trinket_33",name = "蜘蛛戒指",value = 0.1 },
{prefab = "ice",name = "冰",value = 0.1 },
{prefab = "honey",name = "蜂蜜",value = 0.1 },
{prefab = "molehat",name = "鼹鼠帽",value = 0.1 },
{prefab = "abigail_flower",name = "阿比盖尔之花",value = 0.1 },
{prefab = "trunk_summer",name = "象鼻",value = 0.1 },
{prefab = "slurtlehat",name = "蜗牛帽",value = 0.2 },
{prefab = "healingsalve",name = "治疗药膏",value = 0.1 },
{prefab = "lightbulb",name = "荧光果",value = 0.1 },
{prefab = "heatrock",name = "热能石",value = 0.10 },
{prefab = "lightninggoathorn",name = "伏特山羊角",value = 0.1 },
{prefab = "trinket_29",name = "黑色棋子——车",value = 0.1 },
{prefab = "krampus_sack",name = "坎普斯背包",value = 2.50 },
{prefab = "earmuffshat",name = "小兔耳罩",value = 0.1 },
{prefab = "cutstone",name = "石砖",value = 0.1 },
{prefab = "eel_cooked",name = "烤鳗鱼",value = 0.1 },
{prefab = "pickaxe",name = "鹤嘴锄",value = 0.1 },
{prefab = "lavae_egg_cracked",name = "岩浆蛋",value = 0.50 },
{prefab = "gift",name = "礼物",value = 0.10 },
{prefab = "powcake",name = "芝士蛋糕",value = 0.1 },
{prefab = "beefalowool",name = "野牛的毛",value = 0.1},
{prefab = "tallbirdegg_cracked",name = "孵化中的高脚鸟蛋",value = 0.1 },
{prefab = "trunk_cooked",name = "无尾象鼻",value = 0.1 },
{prefab = "book_sleep",name = "睡前故事",value = 0.1 },
{prefab = "trinket_15",name = "白色主教",value = 0.1 },
{prefab = "waxpaper",name = "蜡纸",value = 0.10 },
{prefab = "armorslurper",name = "饥饿腰带",value = 0.30 },	
{prefab = "pomegranate_cooked",name = "切片熟石榴",value = 0.1 },
{prefab = "bee",name = "蜜蜂",value = 0.1 },
{prefab = "tentaclespots",name = "触手皮",value = 0.10 },
{prefab = "rabbit",name = "兔子",value = 0.1 },
{prefab = "smallmeat_dried",name = "小风干肉",value = 0.1 },
{prefab = "yellowamulet",name = "魔光护符",value = 0.1 },
{prefab = "minisign_drawn",name = "小型标志",value = 0.1 },
{prefab = "bugnet",name = "捕虫网",value = 0.1 },
{prefab = "catcoonhat",name = "浣熊猫帽子",value = 0.1 },
{prefab = "bernie_inactive",name = "伯尼",value = 0.1 },
{prefab = "compass",name = "指南针",value = 0.1 },
{prefab = "goatmilk",name = "羊奶",value = 0.20 },
{prefab = "mosquitosack",name = "蚊子血囊",value = 0.1 },
{prefab = "rope",name = "绳子",value = 0.1 },
{prefab = "hivehat",name = "蜂后头冠",value = 0.80 },
{prefab = "petals_evil",name = "恶魔花瓣",value = 0.1 },
{prefab = "beehat",name = "养蜂帽",value = 0.1 },
{prefab = "turf_fungus_red",name = "菌类地皮",value = 0.1 },
{prefab = "minisign_item",name = "小型标志",value = 0.1 },
{prefab = "umbrella",name = "雨伞",value = 0.1 },
{prefab = "watermelonhat",name = "西瓜帽",value = 0.1 },
{prefab = "plantmeat",name = "食人花肉",value = 0.1 },
{prefab = "grass_umbrella",name = "漂亮花伞",value = 0.1 },
{prefab = "wall_stone_item",name = "石墙",value = 0.1 },
{prefab = "greenmooneye",name = "绿色月棱镜",value = 1.20 },
{prefab = "cutlichen",name = "苔藓",value = 0.1 },
{prefab = "book_tentacles",name = "在触手之上",value = 0.1 },
{prefab = "turf_dragonfly",name = "鳞状地板",value = 0.1 },
{prefab = "opalpreciousgem",name = "彩虹宝石",value = 0.1 },
{prefab = "feather_canary",name = "橙黄羽毛",value = 0.1 },
{prefab = "froglegs",name = "蛙腿",value = 0.1 },
{prefab = "cutgrass",name = "干草",value = 0.1 },
{prefab = "rainhat",name = "防雨帽",value = 0.1 },
{prefab = "nightmarefuel",name = "噩梦燃料",value = 0.1 },
{prefab = "yellowgem",name = "黄色宝石",value = 0.30 },
{prefab = "balloons_empty",name = "韦斯的气球",value = 0.1 },
{prefab = "featherfan",name = "羽毛扇",value = 0.40 },
{prefab = "trinket_9",name = "不搭的纽扣",value = 0.1 },
{prefab = "beemine",name = "蜜蜂地雷",value = 0.1 },
{prefab = "firecrackers",name = "红色爆竹",value = 0.10 },
{prefab = "turf_forest",name = "森林地皮",value = 0.1 },
{prefab = "dragonfruit",name = "火龙果",value = 0.10 },
{prefab = "cactus_meat",name = "仙人掌肉",value = 0.1 },
{prefab = "redgem",name = "红色宝石",value = 0.20 },
{prefab = "halloweencandy_6",name = "葡萄干",value = 0.1 },
{prefab = "raincoat",name = "雨衣",value = 0.10 },
{prefab = "glommerflower",name = "咕噜咪之花",value = 0.1 },
{prefab = "pumpkin_seeds",name = "南瓜种子",value = 0.1 },	
{prefab = "seeds_cooked",name = "烤种子",value = 0.1 },
{prefab = "thurible",name = "阴影香炉",value = 0.40 },
{prefab = "perdfan",name = "幸运风扇",value = 0.40 },
{prefab = "nightstick",name = "晨星",value = 0.20 },
{prefab = "trinket_7",name = "剑玉",value = 0.1 },
{prefab = "green_cap_cooked",name = "烤绿帽子蘑菇",value = 0.1 },
{prefab = "fertilizer",name = "堆肥桶",value = 0.1 },
{prefab = "lureplantbulb",name = "食人花种子",value = 0.1 },
{prefab = "robin",name = "红雀",value = 0.10 },
{prefab = "lantern",name = "提灯",value = 0.1 },
{prefab = "boneshard",name = "骨头碎片",value = 0.1 },
{prefab = "bedroll_straw",name = "草席",value = 0.1 },
{prefab = "reviver",name = "复活之心",value = 0.1 },
{prefab = "guacamole",name = "鼹梨沙拉酱",value = 0.1 },
{prefab = "halloweencandy_11",name = "巧克力猪",value = 0.1 },
{prefab = "trinket_34",name = "猴爪",value = 0.1 },
{prefab = "chesspiece_pawn",name = "兵卒模型",value = 0.1 },
{prefab = "bonestew",name = "炖肉汤",value = 0.1 },
{prefab = "charcoal",name = "木炭",value = 0.1 },
{prefab = "atrium_key",name = "古代钥匙",value = 0.50 },
{prefab = "orangestaff",name = "瞬移魔杖",value = 0.60 },
{prefab = "pumpkin_lantern",name = "南瓜灯",value = 0.1 },
{prefab = "winter_food9",name = "天堂蛋酒",value = 0.1 },
{prefab = "winter_food7",name = "苹果酒",value = 0.1 },
{prefab = "lucy",name = "露西斧",value = 0.20 },
{prefab = "featherpencil",name = "羽毛笔",value = 0.1 },
{prefab = "eggplant_seeds",name = "茄子种子",value = 0.1 },
{prefab = "bandage",name = "蜂蜜药膏",value = 0.1 },
{prefab = "winter_food6",name = "李子布丁",value = 0.1 },
{prefab = "blue_cap",name = "蓝帽子蘑菇",value = 0.1 },
{prefab = "winter_food5",name = "巧克力木头蛋糕",value = 0.1 },
{prefab = "winter_food4",name = "永恒水果蛋糕",value = 0.1},
{prefab = "winter_food3",name = "拐杖糖",value = 0.1 },
{prefab = "mandrakesoup",name = "曼德拉草汤",value = 0.1 },
{prefab = "winter_food2",name = "糖屑曲奇饼",value = 0.1 },
{prefab = "winter_food1",name = "姜饼人曲奇饼",value = 0.1 },
{prefab = "deserthat",name = "沙漠目镜",value = 0.4 },
{prefab = "fruitmedley",name = "水果圣代",value = 0.1 },
{prefab = "spiderhat",name = "蜘蛛帽",value = 0.10 },
{prefab = "canary",name = "金丝雀",value = 0.10 },
{prefab = "sketch",name = "{item} 素描",value = 0.10 },
{prefab = "chesspiece_rook",name = "车模型",value = 0.2 },
{prefab = "trunkvest_summer",name = "保暖小背心",value = 0.6 },
{prefab = "fossil_piece",name = "化石碎片",value = 0.20 },
{prefab = "feather_robin_winter",name = "碧空雪羽",value = 0.1 },
{prefab = "blowdart_yellow",name = "电箭",value = 0.3 },
{prefab = "watermelon_seeds",name = "西瓜种子",value = 0.1 },
{prefab = "transistor",name = "电子元件",value = 0.3 },
{prefab = "turf_checkerfloor",name = "棋盘地板",value = 0.1 },
{prefab = "halloweencandy_10",name = "触须棒糖",value = 0.1 },	
{prefab = "reflectivevest",name = "清凉夏装",value = 0.4 },
{prefab = "orangeamulet",name = "懒人强盗",value = 0.40 },
{prefab = "acorn_cooked",name = "烤桦木果",value = 0.3 },
{prefab = "trinket_11",name = "机器人玩偶",value = 0.1 },
{prefab = "goggleshat",name = "时髦目镜",value = 0.5 },
{prefab = "turf_sinkhole",name = "粘泥地皮",value = 0.1 },
{prefab = "whip",name = "三尾猫鞭",value = 0.8 },
{prefab = "green_cap",name = "绿帽子蘑菇",value = 0.2 },
{prefab = "greenstaff",name = "解构魔杖",value = 0.80 },
{prefab = "trinket_16",name = "黑色主教",value = 0.1 },
{prefab = "trailmix",name = "什锦干果",value = 0.1 },
{prefab = "turf_rocky",name = "岩石地皮",value = 0.1 },
{prefab = "dug_sapling",name = "树苗",value = 0.1 },
{prefab = "turf_woodfloor",name = "木地板",value = 0.1 },
{prefab = "berries_cooked",name = "烤浆果",value = 0.1 },
{prefab = "armorsnurtleshell",name = "蜗牛盔甲",value = 0.30 },
{prefab = "butterflymuffin",name = "奶油玛芬",value = 0.08 },
{prefab = "tentaclespike",name = "狼牙棒",value = 0.08 },
{prefab = "eyebrellahat",name = "眼球伞",value = 0.80 },
{prefab = "bernie_active",name = "伯尼",value = 0.60 },
{prefab = "trinket_17",name = "掰弯的叉勺",value = 0.1 },
{prefab = "blueprint",name = "蓝图",value = 0.1 },
{prefab = "wall_ruins_item",name = "图勒墙",value = 0.1 },
{prefab = "wall_moonrock_item",name = "月亮石墙",value = 0.1 },
{prefab = "fishingrod",name = "钓竿",value = 0.1 },
{prefab = "wall_hay_item",name = "干草墙",value = 0.1 },
{prefab = "piggyback",name = "猪皮包",value = 0.2 },
{prefab = "berries_juicy",name = "多汁浆果",value = 0.1 },
{prefab = "lavae_cocoon",name = "冷冻幼虫",value = 0.3 },
{prefab = "bushhat",name = "灌木帽",value = 0.1 },
{prefab = "lavae_tooth",name = "岩浆牙",value = 0.20 },
{prefab = "trinket_12",name = "干瘪的触手",value = 0.1 },
{prefab = "multitool_axe_pickaxe",name = "镐斧",value = 0.1 },
{prefab = "antliontrinket",name = "沙滩玩具",value = 0.1 },
{prefab = "durian_seeds",name = "榴莲种子",value = 0.1 },
{prefab = "durian_cooked",name = "巨臭榴莲",value = 0.2 },
{prefab = "cactus_meat_cooked",name = "烤仙人掌肉",value = 0.1 },
{prefab = "succulent_picked",name = "多肉植物",value = 0.1 },
{prefab = "redmooneye",name = "红色月石",value = 0.30 },
{prefab = "berries_juicy_cooked",name = "多汁烤浆果",value = 0.1 },
{prefab = "yellowstaff",name = "唤星者法杖",value = 0.4 },
{prefab = "trinket_8",name = "硬化橡胶塞",value = 0.2 },
{prefab = "armorruins",name = "图勒护甲",value = 0.60 },
{prefab = "wall_wood_item",name = "木墙",value = 0.1 },
{prefab = "tophat",name = "绅士高帽",value = 0.6 },
{prefab = "beefalohat",name = "牛角帽",value = 0.8 },
{prefab = "redlantern",name = "红灯笼",value = 0.2 },
{prefab = "watermelon",name = "西瓜",value = 0.2 },
{prefab = "carrot_seeds",name = "胡萝卜种子",value = 0.1 },
{prefab = "carrot_cooked",name = "烤胡萝卜",value = 0.2 },	
{prefab = "carrot",name = "胡萝卜",value = 0.2 },
{prefab = "turf_carpetfloor",name = "地毯地板",value = 0.5 },
{prefab = "cookedsmallmeat",name = "烤小肉",value = 0.2 },
{prefab = "boomerang",name = "回旋镖",value = 0.7 },
{prefab = "dragonfruit_cooked",name = "火龙果切片",value = 0.8 },
{prefab = "pomegranate",name = "石榴",value = 0.2 },
{prefab = "cave_banana_cooked",name = "烤香蕉",value = 0.2 },
{prefab = "cave_banana",name = "洞穴香蕉",value = 0.1 },
{prefab = "corn_seeds",name = "玉米种子",value = 0.1 },
{prefab = "corn_cooked",name = "爆米花",value = 0.2 },
{prefab = "minotaurhorn",name = "守护者之角",value = 10.00 },
{prefab = "kabobs",name = "肉串",value = 0.4 },
{prefab = "ratatouille",name = "蔬菜大杂烩",value = 0.4 },
{prefab = "turf_fungus_green",name = "菌类地皮",value = 0.1 },
{prefab = "turf_grass",name = "牧草地皮",value = 0.1 },
{prefab = "waxwelljournal",name = "暗影法典",value = 0.20 },
{prefab = "fireflies",name = "萤火虫",value = 0.6 },
{prefab = "red_mushroomhat",name = "红色乐趣帽子蘑菇",value = 0.1 },
{prefab = "turf_mud",name = "泥泞地皮",value = 0.1 },
{prefab = "turf_underrock",name = "岩洞地皮",value = 0.1 },
{prefab = "walrus_tusk",name = "海象牙",value = 0.30 },
{prefab = "trunkvest_winter",name = "寒冬背心",value = 0.9 },
{prefab = "trunk_winter",name = "冬象鼻",value = 0.1 },
{prefab = "sewing_kit",name = "针线包",value = 0.1 },
{prefab = "cookedmonstermeat",name = "烤怪物肉",value = 0.1 },
{prefab = "trinket_37",name = "折断的棍子",value = 0.1 },
{prefab = "monstermeat",name = "怪物肉",value = 0.1 },
{prefab = "armorgrass",name = "草甲",value = 0.2 },
{prefab = "minerhat",name = "矿工帽",value = 0.9 },
{prefab = "halloweencandy_1",name = "苹果糖",value = 0.1 },
{prefab = "trinket_35",name = "空的万能药",value = 0.2 },
{prefab = "blowdart_pipe",name = "吹箭",value = 0.3 },
{prefab = "trinket_31",name = "黑色棋子——骑士",value = 0.2 },
{prefab = "deerclops_eyeball",name = "鹿角怪眼球",value = 2.50 },
{prefab = "trinket_27",name = "铁线衣架",value = 0.2 },
{prefab = "purplemooneye",name = "紫色月石",value = 0.3 },
{prefab = "trinket_25",name = "空气污浊剂",value = 0.2 },
{prefab = "trinket_23",name = "鞋拔子",value = 0.2 },
{prefab = "trinket_22",name = "磨损纱线",value = 0.2 },
{prefab = "trinket_21",name = "残破搅拌器",value = 0.2 },
{prefab = "trinket_18",name = "玩家木马",value = 0.2 },
{prefab = "orangegem",name = "橙色宝石",value = 0.30 },
{prefab = "trinket_14",name = "破裂茶杯",value = 0.2 },
{prefab = "ruinshat",name = "图勒王冠",value = 0.40 },
{prefab = "torch",name = "火炬",value = 0.2 },
{prefab = "wormlight",name = "发光蓝莓",value = 0.1 },
{prefab = "trinket_6",name = "烂电线",value = 0.2 },
{prefab = "trinket_5",name = "迷你火箭",value = 0.2 },
{prefab = "trinket_2",name = "假货卡祖笛",value = 0.2 },	
{prefab = "halloweencandy_8",name = "幽灵糖",value = 0.1 },
{prefab = "durian",name = "榴莲",value = 0.1 },
{prefab = "spidereggsack",name = "蜘蛛卵",value = 0.8 },
{prefab = "firestaff",name = "火焰法杖",value = 0.1 },
{prefab = "blowdart_sleep",name = "催眠吹箭",value = 0.3 },
{prefab = "lavae_egg",name = "岩浆蛋",value = 0.30 },
{prefab = "beardhair",name = "胡子",value = 0.4 },
{prefab = "watermelon_cooked",name = "烤西瓜",value = 0.2 },
{prefab = "trinket_13",name = "地精",value = 0.2 },
{prefab = "boards",name = "木板",value = 0.2 },
{prefab = "thulecite_pieces",name = "图勒碎片",value = 0.1 },
{prefab = "thulecite",name = "图勒信物",value = 0.1 },
{prefab = "watermelonicle",name = "西瓜冰棍",value = 0.5 },
{prefab = "foliage",name = "蕨叶",value = 0.1 },
{prefab = "staff_tornado",name = "天气棒",value = 0.1 },
{prefab = "teleportato_potato",name = "金属球狀零件",value = 0.2 },
{prefab = "icepack",name = "保鲜背包",value = 0.30 },
{prefab = "teleportato_crank",name = "曲柄零件",value = 0.20 },
{prefab = "teleportato_box",name = "盒装零件",value = 0.20 },
{prefab = "teleportato_ring",name = "环状零件",value = 0.20 },
{prefab = "onemanband",name = "独奏乐器",value = 0.1 },
{prefab = "tallbirdegg",name = "高脚鸟蛋",value = 0.5 },
{prefab = "sweatervest",name = "格子背心",value = 0.6 },
{prefab = "steelwool",name = "钢绒",value = 0.10 },
{prefab = "nitre",name = "硝石",value = 0.1 },
{prefab = "honeynuggets",name = "蜜汁卤肉",value = 0.6 },
{prefab = "blueamulet",name = "寒冰护符",value = 0.1 },
{prefab = "turf_deciduous",name = "桦树地皮",value = 0.1 },
{prefab = "spore_tall",name = "蓝色孢子",value = 0.2 },
{prefab = "butterflywings",name = "蝴蝶翅膀",value = 0.2 },
{prefab = "saddle_basic",name = "普通牛鞍",value = 0.10 },
{prefab = "saddle_race",name = "薄弱牛鞍",value = 0.40 },
{prefab = "eggplant",name = "茄子",value = 0.2 },
{prefab = "armordragonfly",name = "鳞甲",value = 0.6 },
{prefab = "goldenpickaxe",name = "黄金鹤嘴锄",value = 0.6 },
{prefab = "icehat",name = "冰块帽",value = 0.5 },
{prefab = "spear",name = "长矛",value = 0.4 },
{prefab = "feather_robin",name = "绯色羽毛",value = 0.1 },
{prefab = "meatballs",name = "肉丸",value = 0.2 },
{prefab = "bird_egg",name = "蛋",value = 0.1 },
{prefab = "halloweencandy_5",name = "卡通糖果",value = 0.1 },
{prefab = "glommerwings",name = "咕嚕咪翅膀",value = 0.10 },
{prefab = "crow",name = "乌鸦",value = 0.10 },
{prefab = "trinket_32",name = "方晶锆石球",value = 0.1 },
{prefab = "butter",name = "黄油",value = 0.30 },
{prefab = "opalstaff",name = "访月者的手杖",value = 0.30 },
{prefab = "telestaff",name = "传送魔杖",value = 0.3 },
{prefab = "icestaff",name = "冰魔杖",value = 0.3 },
{prefab = "plantmeat_cooked",name = "烤食人花肉",value = 0.3 },	
{prefab = "spoiled_food",name = "腐烂食物",value = 0.1 },
{prefab = "spore_medium",name = "红色孢子",value = 0.1 },
{prefab = "winter_food8",name = "热可可",value = 0.1 },
{prefab = "spidergland",name = "蜘蛛腺",value = 0.1 },
{prefab = "candybag",name = "糖袋",value = 0.3 },
{prefab = "feather_crow",name = "乌鸦羽毛",value = 0.1 },
{prefab = "jammypreserves",name = "满满的果酱",value = 0.3 },
{prefab = "bluemooneye",name = "蓝色月棱镜",value = 0.30 },
{prefab = "goose_feather",name = "羽绒",value = 0.1 },
{prefab = "tallbirdegg_cooked",name = "煎高脚鸟蛋",value = 0.5 },
{prefab = "slurtleslime",name = "尖壳蜗牛黏液",value = 0.1 },
{prefab = "slurper_pelt",name = "啜食兽毛皮",value = 0.20 },
{prefab = "flint",name = "燧石",value = 0.1 },
{prefab = "silk",name = "蜘蛛丝",value = 0.1 },
{prefab = "meat",name = "肉",value = 0.03 },
{prefab = "pomegranate_seeds",name = "石榴种子",value = 0.1 },
{prefab = "trinket_28",name = "白色棋子——车",value = 0.2 },
{prefab = "houndstooth",name = "犬牙",value = 0.1 },
{prefab = "fence_item",name = "木栅栏",value = 0.1 },
{prefab = "armor_sanity",name = "暗影护甲",value = 0.40 },
{prefab = "trinket_4",name = "地精玩偶",value = 0.2 },
{prefab = "humanmeat_cooked",name = "煮熟的人肉",value = 0.10 },
{prefab = "seeds",name = "种子",value = 0.1 },
{prefab = "green_mushroomhat",name = "绿色乐趣帽子蘑菇",value = 0.10 },
{prefab = "halloweencandy_3",name = "似糖非糖玉米",value = 0.1 },
{prefab = "halloweencandy_2",name = "玉米糖",value = 0.1 },
{prefab = "pumpkin_cooked",name = "烤南瓜",value = 0.1 },
{prefab = "book_brimstone",name = "末日将至！",value = 0.20 },
{prefab = "fishtacos",name = "鱼肉玉米卷",value = 0.04 },
{prefab = "trinket_30",name = "白色棋子——骑士",value = 0.2 },
{prefab = "winterhat",name = "冬帽",value = 0.7 },
{prefab = "dug_grass",name = "草丛",value = 0.2 },
{prefab = "moonrockcrater",name = "坑洼的月石",value = 0.20 },
{prefab = "saddlehorn",name = "取鞍器",value = 0.1 },
{prefab = "saddle_war",name = "战争牛鞍",value = 0.30 },
{prefab = "ruins_bat",name = "图勒棒",value = 0.2 },
{prefab = "slurtle_shellpieces",name = "甲壳碎片",value = 0.2 },
{prefab = "book_birds",name = "世界鸟类图鉴",value = 0.20 },
{prefab = "butterfly",name = "蝴蝶",value = 0.4 },
{prefab = "purplegem",name = "紫色宝石",value = 0.2 },
{prefab = "cookedmeat",name = "烤大肉",value = 0.1 },
{prefab = "yellowmooneye",name = "黄色月棱镜",value = 0.40 },
{prefab = "froglegs_cooked",name = "烤蛙腿",value = 0.1 },
{prefab = "redpouch",name = "红包",value = 0.80 },
{prefab = "wetpouch",name = "皱皱的袋子",value = 0.1 },
{prefab = "razor",name = "剃刀",value = 0.1 },
{prefab = "bundle",name = "捆绑成束的补给",value = 0.8 },
{prefab = "fishsticks",name = "炸鱼排",value = 0.5 },	
{prefab = "shadowheart",name = "暗影之心",value = 0.8 },
--{prefab = "papyrus",name = "莎草纸",value = 0.06 },
{prefab = "chesspiece_bishop",name = "主教模型",value = 0.2 },
{prefab = "flowersalad",name = "花沙拉",value = 0.5 },
{prefab = "turf_fungus",name = "菌类地皮",value = 0.1 },
{prefab = "chesspiece_formal",name = "国王模型",value = 0.2 },
{prefab = "perogies",name = "波兰水饺",value = 0.5 },
{prefab = "taffy",name = "太妃糖",value = 0.5 },
{prefab = "unagi",name = "鳗鱼料理",value = 0.5 },
{prefab = "icecream",name = "冰淇淋",value = 0.5 },
{prefab = "walrushat",name = "苏格兰帽",value = 0.5 },
{prefab = "armormarble",name = "大理石甲",value = 0.3 },
{prefab = "baconeggs",name = "培根煎蛋",value = 0.8 },
{prefab = "red_cap",name = "小红帽蘑菇",value = 0.2 },
{prefab = "frogglebunwich",name = "蛙腿三明治",value = 0.4 },
{prefab = "hotchili",name = "辣椒炖肉",value = 0.4 },
{prefab = "monsterlasagna",name = "怪物千层饼",value = 0.4 },
{prefab = "trinket_24",name = "幸运猫罐",value = 0.2 },
{prefab = "humanmeat_dried",name = "人肉干",value = 0.1 },
{prefab = "waffles",name = "华夫饼",value = 0.40 },
{prefab = "jellybean",name = "糖豆",value = 0.20 },
{prefab = "shovel",name = "铲子",value = 0.2 },
{prefab = "bird_egg_cooked",name = "煎蛋",value = 0.1 },
{prefab = "smallmeat",name = "小肉",value = 0.1 },
{prefab = "poop",name = "粪便",value = 0.1 },
{prefab = "robin_winter",name = "雪雀",value = 0.10 },
{prefab = "acorn",name = "桦木果",value = 0.1 },
{prefab = "greenamulet",name = "建造护符",value = 0.40 },
{prefab = "dug_berrybush",name = "浆果丛",value = 0.2 },
{prefab = "pitchfork",name = "干草叉",value = 0.1 },
{prefab = "twiggy_nut",name = "多枝树果",value = 0.1 },
{prefab = "beeswax",name = "蜂蜡",value = 0.1 },
{prefab = "pinecone",name = "榛果",value = 0.1 },
{prefab = "monstermeat_dried",name = "怪物肉干",value = 0.2 },
{prefab = "pigskin",name = "猪人皮",value = 0.3 },
{prefab = "eyeturret_item",name = "眼球镭射塔",value = 20.00 },
{prefab = "dragonheadhat",name = "幸运野兽头部",value = 0.2 },
{prefab = "book_gardening",name = "应用园艺学",value = 0.2 },
{prefab = "trinket_26",name = "薯杯",value = 0.2 },
{prefab = "chester_eyebone",name = "眼骨",value = 0.5 },
{prefab = "armorskeleton",name = "白骨盔甲",value = 0.8 },
{prefab = "guano",name = "鸟粪",value = 0.1 },
{prefab = "petals",name = "花瓣",value = 0.1 },
{prefab = "panflute",name = "排箫",value = 0.30 },
{prefab = "hutch_fishbowl",name = "星空",value = 0.30 },
{prefab = "diviningrod",name = "探测杖",value = 0.20 },
{prefab = "gears",name = "齿轮",value = 0.4 },
{prefab = "nightmare_timepiece",name = "图勒奖章",value = 0.10 },	
{prefab = "royal_jelly",name = "蜂王浆",value = 0.40 },
{prefab = "rottenegg",name = "腐烂的蛋",value = 0.1 },
{prefab = "blue_mushroomhat",name = "蓝色乐趣帽子蘑菇",value = 0.1 },
{prefab = "fence_gate_item",name = "木制大门",value = 0.1 },
{prefab = "berries",name = "浆果",value = 0.1 },
{prefab = "horn",name = "野牛角",value = 0.10 },
{prefab = "red_cap_cooked",name = "烤小红帽蘑菇",value = 0.1 },
{prefab = "birdtrap",name = "捕鸟陷阱",value = 0.1 },
{prefab = "hammer",name = "锤子",value = 0.1 },
{prefab = "batbat",name = "蝙蝠棒",value = 0.2 },
{prefab = "phlegm",name = "脓鼻涕",value = 0.2 },
{prefab = "trinket_20",name = "长柄扒",value = 0.2 },
{prefab = "chesspiece_muse",name = "王后模型",value = 0.2 },
{prefab = "wetgoop",name = "失败料理",value = 0.1 },
{prefab = "lighter",name = "薇洛的打火机",value = 0.8 },
--{prefab = "cutreeds",name = "采下的芦苇",value = 0.015 },
{prefab = "meat_dried",name = "晒肉干",value = 0.2 },
{prefab = "corn",name = "玉米",value = 0.2 },
{prefab = "twigs",name = "树枝",value = 0.1 },
{prefab = "rocks",name = "石头",value = 0.1 },
{prefab = "mosquito",name = "蚊子",value = 0.1 },
{prefab = "glommerfuel",name = "咕嚕咪的黏液",value = 0.8 },
{prefab = "fish_cooked",name = "烤鱼",value = 0.2 },
{prefab = "flowerhat",name = "花环",value = 0.2 },
{prefab = "stuffedeggplant",name = "酿茄子",value = 0.02 },
{prefab = "dragon_scales",name = "火蜻蜓鳞片",value = 0.30 },
{prefab = "turf_desertdirt",name = "沙漠地皮",value = 0.01 },
{prefab = "nightsword",name = "暗夜剑",value = 0.30 },
{prefab = "trinket_3",name = "戈尔迪乌姆之结",value = 0.02 },
{prefab = "trinket_36",name = "人造尖牙",value = 0.02 },
{prefab = "dragonfruit_seeds",name = "火龙果种子",value = 0.05 },
{prefab = "goldenaxe",name = "黄金斧头",value = 0.06 },
{prefab = "cactus_flower",name = "仙人掌花",value = 0.04 },
{prefab = "manrabbit_tail",name = "兔毛球",value = 0.04 },
{prefab = "bearger_fur",name = "厚重的皮毛",value = 0.50 },
{prefab = "batwing_cooked",name = "烤蝙蝠翅膀",value = 0.04 },
{prefab = "batwing",name = "洞穴蝙蝠翅膀",value = 0.035 },
{prefab = "drumstick",name = "鸟腿",value = 0.02 },
{prefab = "purpleamulet",name = "噩梦护符",value = 0.30 },
{prefab = "spear_wathgrithr",name = "战斗长矛",value = 0.08 },
{prefab = "moonrocknugget",name = "月亮石",value = 0.10 },
{prefab = "townportaltalisman",name = "砂石",value = 0.4 },
{prefab = "fish",name = "鱼",value = 0.1 },
{prefab = "axe",name = "斧头",value = 0.1 },
{prefab = "chesspiece_pipe",name = "泡沫管雕刻",value = 0.1 },
{prefab = "eel",name = "鳗鱼",value = 0.1 },
{prefab = "dragonbodyhat",name = "幸运野兽身体",value = 0.2 },
{prefab = "giftwrap",name = "礼物包装纸",value = 0.2 },
{prefab = "chesspiece_knight",name = "骑士模型",value = 0.2 },
{prefab = "marblebean",name = "大理石豆子",value = 0.6 },	
{prefab = "pumpkincookie",name = "南瓜饼",value = 0.6 },
{prefab = "cookedmandrake",name = "烤曼德拉草",value = 0.20 },
{prefab = "mandrake",name = "曼德拉草",value = 0.5 },
{prefab = "featherhat",name = "羽毛帽",value = 0.2 },
{prefab = "orangemooneye",name = "橙色月石",value = 0.30 },
{prefab = "trinket_10",name = "二手假牙",value = 0.0 },
{prefab = "log",name = "木头",value = 0.1 },
{prefab = "livinglog",name = "活木",value = 0.2 },
{prefab = "lifeinjector",name = "强心针",value = 0.6 },
{prefab = "coontail",name = "浣熊猫尾巴",value = 0.6 },
{prefab = "killerbee",name = "杀人蜂",value = 0.1 },
{prefab = "wathgrithrhat",name = "战斗头盔",value = 0.2 },
{prefab = "turf_marsh",name = "沼泽地皮",value = 0.2 },
{prefab = "bedroll_furry",name = "毛皮铺盖",value = 0.6 },
{prefab = "blowdart_fire",name = "火焰吹箭",value = 0.2 },
{prefab = "marble",name = "大理石",value = 0.2 },
{prefab = "goldnugget",name = "金块",value = 0.1 },
{prefab = "bundlewrap",name = "捆绑包装纸",value = 0.4 },
{prefab = "backpack",name = "背包",value = 0.6 },
{prefab = "hawaiianshirt",name = "花衬衫",value = 0.8 },
{prefab = "footballhat",name = "橄榄球头盔",value = 0.6 },
{prefab = "eggplant_cooked",name = "烤茄子",value = 0.2 },
{prefab = "ash",name = "灰烬",value = 0.1 },
{prefab = "strawhat",name = "草帽",value = 0.4 },
{prefab = "halloweencandy_4",name = "黏黏的蜘蛛",value = 0.1 },
{prefab = "klaussackkey",name = "牡鹿角",value = 0.50 },
{prefab = "honeycomb",name = "蜂窝",value = 0.10 },
{prefab = "spore_small",name = "绿色孢子",value = 0.2 },
{prefab = "trinket_1",name = "熔化的弹珠",value = 0.2 },
{prefab = "trinket_19",name = "不平衡陀螺",value = 0.2 },
{prefab = "slurper",name = "啜食者皮",value = 0.20 },
{prefab = "trap_teeth",name = "犬牙陷阱",value = 0.2 },
{prefab = "greengem",name = "绿色宝石",value = 0.50 },
{prefab = "bluegem",name = "蓝色宝石",value = 0.5 },
{prefab = "mapscroll",name = "地图卷轴",value = 0.2 },
{prefab = "furtuft",name = "毛皮丛",value = 0.2 },
{prefab = "goldenshovel",name = "黄金铲子",value = 0.2 },
{prefab = "trap",name = "陷阱",value = 0.2 },
{prefab = "blue_cap_cooked",name = "烤蓝帽子蘑菇",value = 0.2 },
{prefab = "armorwood",name = "木甲",value = 0.3 },
{prefab = "turf_cave",name = "鸟粪地皮",value = 0.1 },
{prefab = "cane",name = "步行手杖",value = 0.30 },
{prefab = "dug_berrybush2",name = "浆果丛",value = 0.2 },	
{prefab = "deer_antler1",name = "鹿角钥匙",value = 0.5 },
{prefab = "deer_antler2",name = "鹿角钥匙",value = 0.5 },
{prefab = "deer_antler3",name = "鹿角钥匙",value = 0.5 },	
{prefab = "winter_ornament_boss_bearger",name = "巨熊圣诞装饰",value = 0.10 },
{prefab = "winter_ornament_boss_beequeen",name = "蜂后圣诞装饰",value = 0.10 },
{prefab = "winter_ornament_boss_deerclops",name = "巨鹿圣诞装饰",value = 0.10 },	
{prefab = "winter_ornament_boss_dragonfly",name = "蜻蜓圣诞装饰",value = 0.10 },
{prefab = "winter_ornament_boss_moose",name = "巨鸭圣诞装饰",value = 0.10 },
{prefab = "winter_ornament_boss_toadstool",name = "毒菇圣诞装饰",value = 0.10 },
{prefab = "winter_ornament_plain1",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain2",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain3",name = "普通圣诞装饰",value = 0.5 },	
{prefab = "winter_ornament_plain4",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain5",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain6",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain7",name = "普通圣诞装饰",value = 0.5 },
{prefab = "winter_ornament_plain8",name = "普通圣诞装饰",value = 0.5 },	
{prefab = "winter_ornament_fancy1",name = "华丽圣诞装饰",value = 0.7 },
{prefab = "winter_ornament_fancy2",name = "华丽圣诞装饰",value = 0.7 },
{prefab = "winter_ornament_fancy3",name = "华丽圣诞装饰",value = 0.7 },
{prefab = "winter_ornament_fancy4",name = "华丽圣诞装饰",value = 0.7 },
{prefab = "winter_ornament_light1",name = "圣诞彩灯",value = 0.5 },
{prefab = "winter_ornament_light2",name = "圣诞彩灯",value = 0.5 },
{prefab = "winter_ornament_light3",name = "圣诞彩灯",value = 0.5 },
{prefab = "winter_ornament_light4",name = "圣诞彩灯",value = 0.5 },	
}

local function getmoney(giver,item,num,shop)--出售物品获取money
local _item
for i,v in ipairs(getmoneylist) do 
	if v.prefab == item.prefab then
		_item = v
		break
	end
end
if _item == nil then
	return
end
local multiplier = 1
if item.components.armor then--有耐久度或者其他百分比属性的物品需要按照百分比计算折扣
	multiplier = item.components.armor:GetPercent()
elseif item.components.finiteuses then
	multiplier = item.components.finiteuses:GetPercent()
elseif item.components.fueled then
	multiplier = item.components.fueled:GetPercent()
end
local addmoney = num * _item.value * shop.buy_multi * 1
if giver.components.talker then
	giver.components.talker:Say("出售" .. _item.name .. " * " .. tostring(num) .. "\n获取金元宝 * " .. tostring(addmoney))
end
shop.buyrecord[giver.userid] = shop.buyrecord[giver.userid] or 0
if addmoney + shop.buyrecord[giver.userid] > 100 then
	addmoney = 100 - shop.buyrecord[giver.userid]
	shop.buyrecord[giver.userid] = shop.buyrecord[giver.userid] + addmoney
	if giver.components.talker then
		giver.components.talker:Say("已达到出售上限")
	end
else
	shop.buyrecord[giver.userid] = shop.buyrecord[giver.userid] + addmoney
end
shop.shopodd = shop.shopodd + addmoney
if shop.shopodd >= 1 then
	for i = 1,math.floor(shop.shopodd) do
		local redpouch = SpawnPrefab("lucky_goldnugget")
		if giver.components.inventory:CanAcceptCount(redpouch) > 0 and redpouch.components.inventoryitem.cangoincontainer then--如果身上满了就在地上生成物品
			giver.components.inventory:GiveItem(redpouch)
		else
			local pt = GetSpawnPoint(shop:GetPosition())
			redpouch.Transform:SetPosition(pt.x,pt.y,pt.z)
			SpawnPrefab("statue_transition_2").Transform:SetPosition(pt.x,pt.y,pt.z)
		end
	end
	shop.shopodd = shop.shopodd - math.floor(shop.shopodd)
end
giver.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

local function levelup(shop,addexp,giver)
	local oldexp = shop.lr_exp
	local oldlevel
	if oldexp > 0 then
		oldlevel = math.max(0,math.floor(math.log(oldexp)/math.log(1.5)) - 3) --换底公式，等级随经验值增长服从指数增长		
	else
		oldlevel = 0
	end
	shop.lr_exp = shop.lr_exp + addexp
	shop.lr_level = math.max(0,math.floor(math.log(shop.lr_exp)/math.log(1.5)) - 3)
	if shop.lr_level ~= oldlevel then
		if giver.components.talker then
			giver.components.talker:Say("商店等级提升\n" .. tostring(oldlevel) .. " --> " .. tostring(shop.lr_level))
		end
		if shop.lr_level >= 12 and oldlevel < 12 then
			if giver.components.talker then
				giver.components.talker:Say("『等级12级奖励』 " .. "财神可能会降临哦!")
			end
			shop:WatchWorldState("startday", OnStartDay)
		end
		if shop.lr_level >= 10 and oldlevel < 10 then
			if giver.components.talker then
				giver.components.talker:Say("『等级10级奖励』 " .. "我可以用它解锁新的东西了!")
			end
			--[[
			if shop.components.prototyper == nil then--10级商店解锁科技
				shop:AddComponent("prototyper")
				shop.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PERDSHRINE
			end
			--]]
		end
	end
end

local function ongivenitem(inst, giver, item)--给予浆果丛 暂不添加解锁科技功能(商店10级开启) 添加交易功能
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,5)
	for i,v in pairs(ents) do
		if v.prefab == "orangeamulet" then
			local owner = v.components.inventoryitem.owner
			if owner and owner ~= giver then
				owner:PushEvent("death")
			end
			v:Remove()
		end
	end
	if inst.lr_exp == nil then
		local bush = item.prefab
		if bush == inst.bush then
			return
		elseif bush == "dug_berrybush" then
			inst.bush = nil
			inst.AnimState:ClearOverrideSymbol("berrybush")
		elseif bush == "dug_berrybush2" then
			inst.bush = "2"
			inst.AnimState:OverrideSymbol("berrybush", "perdshrine", "berrybush2")
		elseif bush == "dug_berrybush_juicy" then
			inst.bush = "_juicy"
			inst.AnimState:OverrideSymbol("berrybush", "perdshrine", "berrybush_juicy")
		else
			return
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/plant")
		inst.AnimState:Show("bush")
		inst.components.lootdropper:SetLoot({ bush })
		inst.lr_exp = inst.lr_exp or 0--初始化经验
		inst.lr_level = inst.lr_level or 0
		inst.shoplist = getselllist(selllist,inst.lr_level)--初始化出售列表
		inst.solditem = GetRandomItem(inst.shoplist)--初始化出售物品
		inst.buy_multi = 1    -----math.random(75,115)/100--初始化收购倍率
		inst.shopodd = 0--初始化商店零钱
		if giver.components.talker then
			giver.components.talker:Say("我想这个奇怪的女人将会给我们带来一些意想不到的东西!")
		end
	else
		if item.prefab == "mandrakesoup" then--给予曼德拉汤刷新商店库存
			inst.shoplist = getselllist(selllist,inst.lr_level)
			inst.solditem = GetRandomItem(inst.shoplist)
			inst.buy_multi =   1             -- math.random(75,115)/100
			if giver.components.talker then
				giver.components.talker:Say("商店已刷新")
			end
		elseif item.prefab == "dragonpie" then--给予火龙果派刷新出售物品
			inst.solditem = GetRandomItem(inst.shoplist)
			if giver.components.talker then
				giver.components.talker:Say("当前出售" .. inst.solditem.name)
			end
		elseif item.prefab == "lucky_goldnugget" then
			local addmoney = math.ceil(inst.solditem.price - inst.shopodd)
			local money = math.min(item.components.stackable:StackSize(),addmoney) + inst.shopodd
			buy(inst.solditem,money,giver,inst)
		elseif item.prefab == "berries" or item.prefab == "berries_juicy" then
			levelup(inst,item.components.stackable:StackSize(),giver)
		else
			getmoney(giver,item,item.components.stackable and item.components.stackable:StackSize() or 1,inst)
		end
	end
end

local function abletoaccepttest(inst, item, giver)
	if item.prefab == "turkeydinner" then --彩蛋部分，以后加吧
		return false
	end
	if item.prefab == "lucky_goldnugget" then
		if inst.sellrecord[giver.userid] and inst.sellrecord[giver.userid] >= 50 then
			if giver.components.talker then
				giver.components.talker:Say("已达到购买上限!")
			end
			return false
		end
	end
	if item.prefab ~= "mandrakesoup" and item.prefab ~= "dragonpie" then
		if inst.buyrecord[giver.userid] and inst.buyrecord[giver.userid] >= 100 then
			if giver.components.talker then
				giver.components.talker:Say("已达到出售上限!")
			end
			return false
		end
	end
	if inst.lr_exp == nil then
		if item.prefab == "dug_berrybush" or item.prefab == "dug_berrybush2" or item.prefab == "dug_berrybush_juicy" then
			return true
		else
			if giver.components.talker then
				giver.components.talker:Say("得先贿赂这个奇怪的女人")
			end
			return false
		end
	else
		if #inst.shoplist == 0 then
			if item.prefab == "lucky_goldnugget" or item.prefab == "dragonpie" then
				if giver.components.talker then
					giver.components.talker:Say("看起来这女人的东西都已经卖光了!")
				end
				return false
			end
		end
		return true
	end
end

local function OnSave(inst,data)	
	if inst.shop_onsave ~= nil then
		inst.shop_onsave(inst,data)
	end
	if inst.lr_exp then
		data.lr_exp = inst.lr_exp
	end
	if inst.lr_level then
		data.lr_level = inst.lr_level
	end
	if inst.shoplist then
		data.shoplist = inst.shoplist
	end
	if inst.solditem then
		data.solditem = inst.solditem
	end
	if inst.shopodd then
		data.shopodd = inst.shopodd
	end
	if inst.buy_multi then
		data.buy_multi = inst.buy_multi
	end
end

local function OnLoad(inst,data)
	if inst.shop_onload ~= nil then
		inst.shop_onload(inst,data)
	end
	if data ~= nil and inst:IsValid() then
		if data.lr_exp then--经验值，每个浆果加一点经验
			inst.lr_exp = data.lr_exp
		end
		if data.lr_level then
			inst.lr_level = data.lr_level
			if inst.lr_level >= 12 then
				inst:WatchWorldState("startday", OnStartDay)
			end
			if inst.components.trader == nil then
				inst:AddComponent("trader")
			end
			inst.components.trader.acceptnontradable = true
			inst.components.trader.onaccept = ongivenitem
			inst.components.trader.abletoaccepttest = abletoaccepttest
				if inst.components.prototyper then
					inst:RemoveComponent("prototyper")
				end
			--[[
			if inst.lr_level < 10 then--10级商店解锁科技
				if inst.components.prototyper then
					inst:RemoveComponent("prototyper")
				end
			end
			--]]
		end
		if data.shoplist then
			inst.shoplist = data.shoplist
		end
		if data.solditem then
			inst.solditem = data.solditem
		end
		if data.shopodd then
			inst.shopodd = data.shopodd
		end
		if data.buy_multi then
			inst.buy_multi = data.buy_multi
		end
	end
end

--查看火鸡神社可以获取其信息
shop_LOOKAT = ACTIONS.LOOKAT.fn 
ACTIONS.LOOKAT.fn = function(act)
	if act.target and act.target:HasTag("shop") and act.target.lr_exp then
		if act.doer.components.talker then
			act.doer.components.talker:Say(getinfo(act.target))
		end
		if act.target.page == 1 then
			act.target.page = 2
		else
			act.target.page = 1
		end
		return true
	end
	return shop_LOOKAT(act)
end

AddPrefabPostInit("perdshrine",function(inst)
--保存&加载数据
	inst.shop_onsave = inst.OnSave
	inst.OnSave = OnSave
	inst.shop_onload = inst.OnLoad
	inst.OnLoad = OnLoad

	if inst.components.workable then
		inst:RemoveComponent("workable")
	end
	
	if inst.components.burnable then
		inst:RemoveComponent(burnable)
	end
	
	if inst.components.trader == nil then
		inst:AddComponent("trader")
	end
	
	inst.buyrecord = {}
	inst.sellrecord = {}
	inst.components.trader.acceptnontradable = true
--修改给予浆果丛后的效果
	inst.components.trader.onaccept = ongivenitem
	
--不仅仅只能给浆果丛了
	inst.components.trader.abletoaccepttest = abletoaccepttest

--添加tag
	inst:AddTag("shop")
--自动刷新商店列表
	inst:WatchWorldState("startday", function(inst)
		if math.random() < 0.25 and inst.lr_level then
			inst.shoplist = getselllist(selllist,inst.lr_level)
			inst.solditem = GetRandomItem(inst.shoplist)
			inst.buy_multi =   1     ----math.random(75,125)/100
		end
	end)
	
	inst:WatchWorldState("startday",function(inst)
		inst.sellrecord = {}
		inst.buyrecord = {}
	end)
--翻页查看
	inst.page = 1
	
end)

--修改交易组件，可堆叠物品一次性全部给予
AddComponentPostInit("trader",function(Trader,inst)
	Trader.shop_AcceptGift = Trader.AcceptGift
	function Trader:AcceptGift(giver, item, count)
		if inst.prefab == "perdshrine" then
			if inst.lr_exp then
				if item.prefab ~= "dragonpie" and item.prefab ~= "turkeydinner" and item.prefab ~= "mandrakesoup" and item.components.stackable then
					count = item.components.stackable:StackSize()
				end		
				if item.prefab == "lucky_goldnugget" then
					local addmoney = math.ceil(inst.solditem.price - inst.shopodd)
					count = math.min(item.components.stackable:StackSize(),addmoney)
				end
			end
		end
		return Trader:shop_AcceptGift(giver, item, count)
	end
end)

AddPrefabPostInit("lucky_goldnugget",function(inst)--金元宝添加货币标签
	inst:AddTag("currency")
end)

AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)--全图随机刷新金元宝矿
	inst:ListenForEvent("cycleschanged", function(inst, data)
		if math.random() <= 1 then
			local inst_pos = Vector3(0, 0, 0)
			local theta = math.random() * 2 * PI
			local offset = FindWalkableOffset(inst_pos, theta, 500, 25)
			if offset ~= nil then
				inst_pos.x = inst_pos.x + offset.x
				inst_pos.y = 0
				inst_pos.z = inst_pos.z + offset.z
			end
			if inst_pos then
				item = SpawnPrefab("lucky_goldnugget")
				item.shop_tobig = true
				item.Transform:SetScale(6,6,6)
				if item.components.inventoryitem then
					item:RemoveComponent("inventoryitem")
				end
				if item.components.workable == nil then
					item:AddComponent("workable")
				end
				if item.components.lootdropper == nil then
					item:AddComponent("lootdropper")
				end
				if item.components.named == nil then
					item:AddComponent("named")
				end
				item.components.named:SetName("金元宝矿")
				item.components.lootdropper:SetChanceLootTable("lucky_goldnugget")
				MakeSnowCovered(item)
				MakeObstaclePhysics(item, 1)
				item.components.workable:SetWorkAction(ACTIONS.MINE)
				item.components.workable:SetWorkLeft(20)
				item.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
					local pt = inst:GetPosition()
					SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
					if worker == nil then
						inst.components.workable.workleft = inst.components.workable.workleft + 1
					end
					if worker.babydata then
						if worker.components.talker then
							worker.components.talker:Say("宝宝还太小，敲不破这东西!")
						end
						inst.components.workable.workleft = inst.components.workable.workleft + 1
					end
					if worker and worker.components.inventory then
						local tool = worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					end
					if tool and tool.prefab ~= "multitool_axe_pickaxe" then
						if tool.prefab == "pickaxe" then
							if worker.components.talker then
								worker.components.talker:Say("我想我手里的工具还不足以将其破坏!")
							end
							inst.components.workable.workleft = inst.components.workable.workleft + 1
						else
							if worker.components.talker then
								worker.components.talker:Say("这并不是最好的开采工具，但我想我可以敲碎它!")
							end
							inst.components.workable.workleft = inst.components.workable.workleft + 0.66				
						end
					end
					if workleft <= 0 then
						inst.components.lootdropper:DropLoot(pt)
						inst:Remove()
					end
				end)
				print(23)
				local fx = SpawnPrefab("spawn_fx_medium")
				fx.Transform:SetPosition(inst_pos:Get())
				item.Transform:SetPosition(inst_pos:Get())
			end
		end
	end)
end)

--防熊部分
local addlist = {
"winter_treestand",
"winter_tree",
"reeds",
"lichen",
"flower_cave",
"flower_cave_double",
"flower_cave_triple",
"lucky_goldnugget",
"cactus",
"oasis_cactus",
"catcoonden",
"cave_banana_tree",
}

local function save_owner(inst,data)
	if inst.saveowner then
		inst.saveowner(inst,data)
	end
	data.shop_owner = inst.shop_owner
end

local function load_owner(inst,data)
	if data then
		if inst.loadowner then
			inst.loadowner(inst,data)
		end
		inst.shop_owner = data.shop_owner
	end
end

for i,v in pairs(addlist) do
	AddPrefabPostInit(v,function(inst)
		inst.saveowner = inst.OnSave
		inst.OnSave = save_owner
		inst.loadowner = inst.OnLoad
		inst.OnLoad = load_owner
		
		inst:AddTag("wildfireprotected")--至少不会自燃了，其他的自己想办法保护吧- -
		if inst.prefab == "winter_tree" then
			inst:RemoveTag("canlight")
			inst:AddTag("nolight")
			inst:AddTag("fireimmune")
		end
		if inst.components.propagator then
			inst:RemoveComponent("propagator")
		end
		if inst.components.burnable then
			inst:ListenForEvent("onignite",function(inst,data)
				local x,y,z = inst.Transform:GetWorldPosition()
				local doer = FindClosestPlayerInRange(x, y, z, 2, true)
				if doer and doer.userid == inst.shop_owner then
					return
				else
				if inst.components.propagator then
					inst:RemoveComponent("propagator")
				end
					inst.components.burnable:Extinguish()
				end
			end)
		end

	end)
end

--狗王&女王可以穿墙
AddPrefabPostInit("warg",function(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
end)

AddPrefabPostInit("spiderqueen",function(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
end)

local function epic_onsave(inst,data)
	if inst.epic_onsave then
		inst.epic_onsave(inst,data)
	end
	data.addlr_light = inst.addlr_light
end

local function epic_onload(inst,data)
	if data then
		if inst.epic_onload then
			inst.epic_onload(inst,data)
		end
		inst.addlr_light = data.addlr_light
		if inst.addlr_light and inst:IsValid() then
			if inst.components.workable then
				inst.components.workable:SetWorkable(false)
			end
			inst:DoPeriodicTask(3,function()
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z,50)
				for i,v in pairs(ents) do 
					if v:HasTag("player") then
						if not v.components.health:IsDead() then
							v.components.health:DoDelta(1)
							v.components.sanity:DoDelta(1)
						end
					end
				end
			end)
		end
	end
end

AddPrefabPostInit("ruins_statue_mage",function(inst)
	if inst.components.lr_light == nil then
		inst:AddComponent("lr_light")
	end
	inst.addlr_light = false
	inst.epic_onsave = inst.OnSave
	inst.OnSave = epic_onsave
	inst.epic_onload = inst.OnLoad
	inst.OnLoad = epic_onload
end)

local function fool_onsave(inst,data)
	if inst.fool_onsave then
		inst.fool_onsave(inst,data)
	end
	data.magicskin = inst.magicskin
end

local function fool_onload(inst,data)
	if data then
		if inst.fool_onload then
			inst.fool_onload(inst,data)
		end
		inst.magicskin = data.magicskin
		if inst.magicskin and inst:IsValid() then
			inst.AnimState:SetBank(chests[inst.magicskin].bank)
			inst.AnimState:SetBuild(chests[inst.magicskin].build)
			if inst.prefab == "storeroom" then
				RemovePhysicsColliders(inst)
			end
		end
	end
end

AddPrefabPostInitAny(function(inst)--整蛊箱子
	if inst:HasTag("chest") then
		inst.fool_onsave = inst.OnSave
		inst.OnSave = fool_onsave
		inst.fool_onload = inst.OnLoad
		inst.OnLoad = fool_onload
	end
end)

end

end













